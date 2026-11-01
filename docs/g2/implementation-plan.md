# G2 Implementation Plan

> Execute inline with superpowers:executing-plans and test-driven-development. No subagents, commits, pushes, production services, or live spending are authorized.

**Goal:** Deliver an isolated, interactive native iPhone prototype and executable local technical probes, with honest separation of simulator, fixture, and real-device evidence.

**Architecture:** `DodayG2` hosts SwiftUI journeys and Apple/Google adapters. `G2Core` owns deterministic privacy, request triggers, image processing, account stores and the share inbox. `DodayG2ShareExtension` only writes account-owned inbox items. The Node lab proxy defaults to fixture and denies live requests.

**Tech Stack:** iOS 17.0, SwiftUI, AVFoundation, PhotosUI, Core Location, ImageIO, SwiftData, Google Maps 11.2.0 (SPM), Node built-ins.

**Spec:** G1 APPROVED baseline in ../g1/; G2 proposal approved by project owner in this conversation on 2026-10-31, Asia/Ho_Chi_Minh. This is implementation-plan approval, not final UX acceptance, LEGAL signoff, a live budget, or G2 acceptance.

## Global Constraints

- Preserve `Sources/Doday`, `project.yml`, roadmap and all G1 documents byte-for-byte.
- Add `project-g2.yml`; generate only the existing ignored `Doday.xcodeproj`.
- iPhone-first, iPad compatibility; Vietnamese and English; Camera and Map only as primary areas.
- No public/friends/community UI, real authentication, production sync, or backend G3.
- Original and draft durable before derivative processing; no fake synced status.
- Hide/zone default on, consent separate; protected input never outbound; GPS recognition samples RAM <60 seconds, no payload logging.
- No passive Places/media/reviews/geocoding/routes. Search >=2 characters, 400 ms debounce, <=2 retries, breaker 5 failures/60 seconds, 60-second cooldown, one probe.
- Fixture data is synthetic Doday-owned data, not evidence of Google API behavior.
- Live Google remains disabled. A proposed USD 5 smoke budget is NOT approved.

## Tasks

### 1. Isolated build and test harness
- [x] Run existing `Doday` baseline test on the available iPhone 17 simulator.
- [x] Add overlay targets `G2Core`, `DodayG2`, extension and core/UI tests.
- [x] Add behavior-first XCTest cases, generate project and record expected RED output.
- [x] Keep private signing/key configuration untracked and out of generated evidence.

### 2. Deterministic domain and local probes
- [x] PrivacyGate checks account/revision, Hide, verified zones, error-circle intersections, consent, sample freshness, and monotonic retention before send/retry/receive.
- [x] TriggerPolicy rejects passive events and constructs minimal masks for explicit search/details/photos/reviews only.
- [x] ImagePipeline normalizes all EXIF orientations, center-crops, downsizes without upscaling and strips metadata by fresh encoding; validate decoded files.
- [x] DraftStore persists source first, then explicit SwiftData save; recovery handles processing errors without deleting sources or duplicating IDs.
- [x] ShareInbox accepts real NSItemProvider URL/text, validates HTTPS URLs and account epoch under coordinated access, writes atomically, deduplicates per account.
- [x] Node proxy tests cover deny-live, minimal masks, budget contention, finite retry, breaker and opaque error responses.
- [x] Run GREEN core and proxy tests; capture sanitized results, not source GPS.

### 3. Native prototype and real adapters
- [x] Implement Camera/Map navigation, review/title/Hide, saved list/collections/status, details, pending links, journal and privacy settings.
- [x] Add real AVFoundation still capture/switch, PhotosUI file import, permission states and Core Location foreground sample handling.
- [x] Keep recognition thresholds unfrozen and live automatic assignment disabled. Fixture branches are labeled.
- [x] Add NSItemProvider share target; no authentication means no ownerless saved request.
- [ ] (BLOCKED: live not approved) Wire Google Maps only after the live prerequisites; proxy adapter has no direct Google Web Service key.
- [x] Add deterministic scenario controls in a separate Lab screen, accessible outside normal journeys.
- [x] Add VI/EN localization, Dynamic Type, VoiceOver labels and stable layouts.

### 4. Verification
- [x] Run core tests, proxy tests, UI smoke journeys and baseline regression.
- [x] (partial: iPhone 17 VI/EN/Dynamic Type AX; iPhone 17e/Pro Max not captured) Launch simulator and inspect small/large layouts through simulator screenshots, not browser preview.
- [x] Review privacy/trigger/store/extension boundaries inline; fix findings and rerun affected tests.
- [x] Recheck source/G1 hashes and Git diff; do not include raw device identifiers, URLs, coordinates or secrets in evidence.

### 5. Evidence and external gates
- [x] Complete README, ux-spec, technical-spikes, measurement-plan, usability-report, evidence and decisions.
- [x] Record actual date/build/dirty state/environment and per-case outcomes.
- [x] Keep real-device, SDK/API live, real TikTok/Instagram source versions, Q-17, LEGAL and calibration evidence BLOCKED/NOT_RUN until actually performed.
- [x] G2 stayed IN_PROGRESS during implementation. It moved to READY_FOR_REVIEW on 01/11/2026 only after the owner's decisions in decisions.md, and the owner then approved it (G2-SIGNOFF). G3 has not started.

## Progress note (31/10/2026)

Checked items were executed on the Mac/simulator only. Physical-iPhone, live Google, real share sources, Q-17 and LEGAL remain open; see `evidence.md`. The first execution run stopped on a provider error and was resumed on the owner's instruction "Tiếp tục công việc" without changing the approved scope.

## Verification Commands

```sh
xcodegen generate --spec project-g2.yml
xcodebuild -project Doday.xcodeproj -scheme G2CoreTests -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO -collect-test-diagnostics never test
xcodebuild -project Doday.xcodeproj -scheme DodayG2 -destination 'platform=iOS Simulator,name=iPhone 17' -derivedDataPath /tmp/doday-g2 CODE_SIGNING_ALLOWED=NO build
node --test spikes/g2/places-proxy/*.test.mjs
```
