import http from 'node:http';
import { mkdir, open, readFile, rename, unlink } from 'node:fs/promises';
import { join } from 'node:path';
import { fileURLToPath } from 'node:url';

export function requestMask(event, input) {
  if (event === 'search' && (typeof input.query !== 'string' || input.query.trim().length < 2 || input.query.length > 120)) throw new Error('input');
  const masks = {
    search: 'places.id,places.displayName,places.location,places.businessStatus,places.attributions',
    details: 'id,displayName,formattedAddress,location,businessStatus,attributions,movedPlace,movedPlaceId',
    photos: 'id,photos,attributions', reviews: 'id,reviews,attributions'
  };
  if (!masks[event]) throw new Error('trigger');
  return masks[event];
}
export class Breaker {
  failures = []; openedAt = null; probe = false;
  enter(now) {
    if (this.openedAt === null) return true;
    if (now - this.openedAt < 60 || this.probe) return false;
    this.probe = true; return true;
  }
  failure(now) {
    this.failures = this.failures.filter(value => now - value < 60); this.failures.push(now);
    if (this.probe || this.failures.length >= 5) { this.openedAt = now; this.probe = false; }
  }
  success() { this.failures = []; this.openedAt = null; this.probe = false; }
}
export async function retry(operation, { delay = ms => new Promise(resolve => setTimeout(resolve, ms)), allowed = () => true } = {}) {
  for (let attempt = 0; attempt <= 2; attempt++) {
    if (!allowed()) throw Object.assign(new Error('gate'), { permanent: true });
    try { return await operation(attempt); }
    catch (error) {
      if (error.permanent || error.name === 'AbortError' || attempt === 2) throw error;
      await delay(400 * 2 ** attempt);
    }
  }
}
export async function reserve(root, ceiling, units) {
  if (!Number.isSafeInteger(ceiling) || !Number.isSafeInteger(units) || units <= 0 || ceiling < 0) throw new Error('budget');
  await mkdir(root, { recursive: true, mode: 0o700 });
  const lockPath = join(root, 'budget.lock');
  let lock;
  // Contention/stale locks deny, never assume an unused allowance. Reservations are never refunded.
  for (let i = 0; i < 50; i++) {
    try { lock = await open(lockPath, 'wx', 0o600); break; }
    catch (error) { if (error.code !== 'EEXIST') throw error; await new Promise(resolve => setTimeout(resolve, 2)); }
  }
  if (!lock) throw new Error('locked');
  try {
    let used = 0;
    try { used = JSON.parse(await readFile(join(root, 'budget.json'), 'utf8')).used; }
    catch (error) { if (error.code !== 'ENOENT') throw error; }
    if (!Number.isSafeInteger(used) || used < 0 || used + units > ceiling) throw new Error('budget');
    const temp = join(root, 'budget.tmp');
    const file = await open(temp, 'w', 0o600);
    try { await file.writeFile(JSON.stringify({ used: used + units })); await file.sync(); } finally { await file.close(); }
    await rename(temp, join(root, 'budget.json'));
    return used + units;
  } finally { await lock.close(); await unlink(lockPath); }
}

export function createLabServer() {
  return http.createServer(async (request, response) => {
    const reply = (code, data) => { response.writeHead(code, { 'Content-Type': 'application/json', 'Cache-Control': 'no-store' }); response.end(JSON.stringify(data)); };
    // G2 has NO authorized live allowance. No environment variable/client flag can unlock it.
    if (request.url?.startsWith('/live/')) return reply(423, { error: 'LIVE_LOCKED', mode: 'locked' });
    if (request.method !== 'POST' || !request.url?.startsWith('/fixture/')) return reply(404, { error: 'NOT_FOUND' });
    let length = 0; const chunks = [];
    try {
      for await (const chunk of request) {
        length += chunk.length; if (length > 4096) return reply(413, { error: 'INPUT' }); chunks.push(chunk);
      }
      const input = JSON.parse(Buffer.concat(chunks).toString());
      if (['latitude', 'longitude', 'location', 'locationBias', 'coordinates'].some(key => key in input)) return reply(400, { error: 'NO_COORDINATES' });
      const event = request.url.slice('/fixture/'.length);
      const mask = requestMask(event, input);
      reply(200, { mode: 'fixture', mask, items: event === 'search' ? [{ id: 'fixture-garden', label: 'Doday Test Garden', source: 'Doday synthetic' }] : [],
        notice: 'No Google call; no third-party payload.' });
    } catch { reply(400, { error: 'INPUT_OR_TRIGGER' }); }
  });
}
if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const port = Number(process.env.PORT || 8787);
  const server = createLabServer();
  server.listen(port, '127.0.0.1', () => console.log(`Doday G2 fixture-only proxy on 127.0.0.1:${port}; live LOCKED`));
}
