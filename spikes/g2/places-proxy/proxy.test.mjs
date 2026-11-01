import test from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { createLabServer, requestMask, Breaker, reserve, retry } from './proxy.mjs';

test('passive events and short search never acquire a mask', () => {
  for (const event of ['appOpen', 'cameraOpen', 'capture', 'save', 'mapOpen', 'pan', 'zoom']) {
    assert.throws(() => requestMask(event, {}));
  }
  assert.throws(() => requestMask('search', { query: 'a' }));
  assert.equal(requestMask('photos', {}), 'id,photos,attributions');
  assert.equal(requestMask('reviews', {}), 'id,reviews,attributions');
  assert.ok(!requestMask('details', {}).includes('photos'));
});

test('server refuses live even with arbitrary client approval and returns labeled fixtures only', async () => {
  const server = createLabServer();
  await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
  const base = `http://127.0.0.1:${server.address().port}`;
  try {
    const denied = await fetch(base + '/live/details', {
      method: 'POST', body: JSON.stringify({ approved: true, key: 'not-a-key' })
    });
    assert.equal(denied.status, 423);
    const fixture = await fetch(base + '/fixture/search', {
      method: 'POST', body: JSON.stringify({ query: 'Garden' })
    });
    assert.equal((await fixture.json()).mode, 'fixture');
    assert.equal((await fetch(base + '/fixture/pan', { method: 'POST', body: '{}' })).status, 400);
  } finally { await new Promise(resolve => server.close(resolve)); }
});

test('two retries maximum and cancellation never retries', async () => {
  let count = 0;
  await assert.rejects(retry(async () => { count++; throw new Error('transient'); }, { delay: async () => {} }));
  assert.equal(count, 3);
  count = 0;
  await assert.rejects(retry(async () => { count++; throw Object.assign(new Error('stop'), { permanent: true }); }));
  assert.equal(count, 1);
});

test('breaker opens after five failures in sixty seconds, single probe after cooldown', () => {
  const breaker = new Breaker();
  for (let i = 0; i < 5; i++) { assert.ok(breaker.enter(i)); breaker.failure(i); }
  assert.equal(breaker.enter(59), false);
  assert.equal(breaker.enter(64), true);
  assert.equal(breaker.enter(64), false);
  breaker.success();
  assert.equal(breaker.enter(65), true);
});

test('atomic persistent reservations cannot exceed a tiny synthetic test allowance', async () => {
  const root = await mkdtemp(join(tmpdir(), 'doday-g2-budget-'));
  try {
    const outcomes = await Promise.allSettled(Array.from({ length: 10 }, () => reserve(root, 2, 1)));
    assert.equal(outcomes.filter(x => x.status === 'fulfilled').length, 2);
    await assert.rejects(reserve(root, 2, 1));
  } finally { await rm(root, { recursive: true, force: true }); }
});
