import Foundation
import G2Core
import ImageIO
import SwiftUI
import UIKit

enum LocationPurpose { case review, zone, nearby }

enum SyntheticSample: String, CaseIterable, Identifiable {
    case outside, inside, edge, approximate, stale
    var id: String {
        rawValue
    }
}

/// Zone verdict for one camera photo at one policy revision; the sample behind it is already gone.
private struct CameraZoneVerdict {
    let draft: UUID
    let revision: Int
    let status: ZoneStatus
}

@MainActor
final class AppModel: ObservableObject {
    @Published var english = UserDefaults.standard.string(forKey: "g2.language") == "en" {
        didSet { UserDefaults.standard.set(english ? "en" : "vi", forKey: "g2.language") }
    }

    @Published var onboarded: Bool {
        didSet { UserDefaults.standard.set(onboarded, forKey: "g2.onboarded") }
    }

    @Published var accountID: String?
    @Published var policy = PrivacyPolicy.safeDefault(accountID: "")
    @Published var drafts: [DraftSummary] = []
    @Published var saved: [SavedIntent] = []
    @Published var pending: [InboxItem] = []
    @Published var error: String?
    @Published var notice: String?
    @Published var noticeIsError = false
    @Published var reviewID: UUID?
    @Published var currentHidden = true
    // One-tap override for the next capture only; the new-photo default in Settings is never changed by it.
    @Published var nextHidden: Bool?
    @Published var processing = false
    @Published var gate: GateResult? {
        didSet { gateUptime = ProcessInfo.processInfo.systemUptime }
    }

    private var gateUptime: TimeInterval = 0
    @Published var sourceHasGPS = false
    @Published var libraryCheck: LibraryPlaceCheck?
    @Published var profile = false
    @Published var activeArea = 0
    @Published var saveNotice = false
    @Published var nearbyResults: [PrototypePlace]?
    @Published var nearbyBlocked: GateResult?
    /// Zone status of the photo under review. Only this verdict is kept, never the sample behind it.
    @Published private(set) var reviewZone = ZoneStatus.uncertain
    private var cameraZone: CameraZoneVerdict?
    @Published private(set) var importing = false
    private var importTask: Task<Void, Never>?
    private var importToken: UUID?
    // G2 timing probes kept in RAM only; preliminary until measured on the approved device set (Q-01/Q-03).
    @Published var captureDurableMs: [Double] = []
    @Published var cameraReadyMs: [Double] = []
    let location = LocationEngine()
    let places = PlacesLab()
    let root: URL
    private(set) var store: DraftStore?
    private(set) var savedStore: SavedStore?
    private var policyStore: PolicyStore?
    private(set) var inbox: ShareInbox?
    private(set) var owner: InboxOwner?
    let sharedAvailable: Bool
    private var processingTask: Task<Void, Never>?
    private var purpose = LocationPurpose.review

    func t(_ vi: String, _ en: String) -> String {
        english ? en : vi
    }

    /// Previews pass the UI-test flags directly so each canvas render starts from a wiped fixture store.
    init(arguments: [String] = ProcessInfo.processInfo.arguments) {
        let testing = arguments.contains("--g2-ui-test")
        onboarded = testing ? !arguments.contains("--g2-onboarding") : UserDefaults.standard
            .bool(forKey: "g2.onboarded")
        if testing, arguments.contains("--g2-english") {
            english = true
        } else if testing {
            english = false
        }
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        root = base.appendingPathComponent(testing ? "G2-UI-Test" : "G2-Lab")
        // --g2-keep-data relaunches against the same files to prove drafts survive a terminated process.
        let wipe = testing && !arguments.contains("--g2-keep-data")
        if wipe {
            try? FileManager.default.removeItem(at: root)
        }
        let shared = FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: "group.com.ckiet1612.doday.g2")
        sharedAvailable = shared != nil
        let inboxRoot = (shared ?? root).appendingPathComponent(testing ? "test-inbox" : "share-inbox")
        // With an App Group (signed builds, previews) the test inbox lives outside root, so wipe it as well.
        if wipe {
            try? FileManager.default.removeItem(at: inboxRoot)
        }
        do {
            try LocalFiles.directory(root)
            inbox = try ShareInbox(root: inboxRoot)
            if wipe {
                try inbox?.setOwner(nil)
            } else if let prior = try inbox?.owner() {
                try loadAccount(prior)
            }
        } catch { self.error = "Local storage unavailable / Không mở được kho trên máy" }
        location.onSample = { [weak self] sample in self?.received(sample) }
    }

    func login(_ suffix: String = "a") {
        do {
            let next = InboxOwner(accountID: "fixture-account-" + suffix, epoch: UUID())
            try inbox?.setOwner(next); try loadAccount(next)
        } catch { reportStorage() }
    }

    private func loadAccount(_ value: InboxOwner) throws {
        location.discard(); processingTask?.cancel(); cancelImport(); reviewID = nil; nextHidden = nil
        let drafts = try DraftStore(root: root, accountID: value.accountID)
        let settings = try PolicyStore(root: root, accountID: value.accountID)
        let intents = try SavedStore(root: root, accountID: value.accountID)
        store = drafts; policyStore = settings; savedStore = intents
        policy = try settings.load(); owner = value; accountID = value.accountID
        resetTransient(); refresh()
    }

    func logout() {
        do { try inbox?.setOwner(nil) } catch { reportStorage(); return }
        location.discard(); processingTask?.cancel(); processingTask = nil; cancelImport()
        accountID = nil; owner = nil; store = nil; savedStore = nil; policyStore = nil
        drafts = []; pending = []; saved = []; reviewID = nil; nextHidden = nil
        resetTransient(); policy = .safeDefault(accountID: "")
    }

    private func resetTransient() {
        gate = nil; sourceHasGPS = false; libraryCheck = nil; nearbyResults = nil; nearbyBlocked = nil; saveNotice =
            false
        cameraZone = nil; reviewZone = .uncertain
    }

    func refresh() {
        do {
            drafts = try store?.list() ?? []; saved = try savedStore?.list() ?? []
            pending = try accountID.map { try inbox?.items(for: $0) ?? [] } ?? []
        } catch { reportStorage() }
    }

    func reportStorage() {
        error = t(
            "Không ghi được trên máy. Chưa xác nhận lưu.",
            "Could not write to this device. Save not confirmed."
        )
    }

    func changePolicy(_ change: (inout PrivacyPolicy) -> Void) {
        guard accountID != nil else { return }
        var next = policy; change(&next); next.revision += 1
        do {
            // Any revision drops the RAM sample and pending results; nothing is replayed under the new policy.
            try policyStore?.save(next); policy = next
            location.discard(); gate = nil; nearbyResults = nil; nearbyBlocked = nil; cameraZone = nil
            updateReviewZone()
        } catch { reportStorage() }
    }

    var reviewDraft: DraftSummary? {
        drafts.first { $0.id == reviewID }
    }

    /// The sample is gone right after evaluation; an "allowed" verdict must not outlive its 60-second window either.
    var liveGate: GateResult? {
        guard gate == .allowed else { return gate }
        return ProcessInfo.processInfo.systemUptime - gateUptime < 60 ? gate : .expired
    }

    func currentHideChanged(_ hidden: Bool) {
        currentHidden = hidden
        changePolicy { _ in }
        guard let id = reviewID, let draft = reviewDraft else { return }
        do {
            try store?.update(id, title: draft.title, hidden: hidden)
            if hidden {
                try store?.attach(id, placeID: nil); libraryCheck = nil
            }
            refresh()
        } catch { reportStorage() }
    }

    func capture(_ bytes: Data, origin: String) {
        guard let store, let accountID else { profile = true; return }
        let started = ContinuousClock.now
        do {
            // Library time comes from the photo itself; otherwise the UI labels the time as "added".
            let metadata = origin.hasPrefix("library") ? try? ImagePipeline.inspect(bytes) : nil
            let id = try store.capture(
                source: bytes,
                origin: origin,
                capturedAt: origin == "camera" ? Date() : metadata?.capturedAt
            )
            currentHidden = nextHidden ?? policy.hide; nextHidden = nil
            try store.update(id, title: "", hidden: currentHidden)
            let elapsed = started.duration(to: .now).components
            captureDurableMs =
                Array((captureDurableMs + [Double(elapsed.seconds) * 1000 + Double(elapsed.attoseconds) / 1e15])
                        .suffix(20))
            reviewID = id; resetTransient(); saveNotice = true
            sourceHasGPS = metadata?.hasGPS ?? false
            refresh(); updateReviewZone(); processing = true
            let scenario = places.scenario
            processingTask = Task {
                let output: Result<ProcessedImage, Error> = await Task.detached(priority: .userInitiated) {
                    Result { try ImagePipeline.process(source: scenario == .corruptImage ? Data([0, 1]) : bytes) }
                }.value
                guard !Task.isCancelled, self.accountID == accountID else { return }
                do {
                    try store.complete(id, output: output.get())
                } catch {
                    do { try store.markProcessingFailed(id) } catch { self.reportStorage() }
                }
                self.processing = false; self.refresh()
            }
        } catch { reportStorage() }
    }

    func openDraft(_ draft: DraftSummary) {
        reviewID = draft.id; currentHidden = draft.hidden; resetTransient()
        if let data = try? Data(contentsOf: store?.sourceURL(draft.id) ?? URL(fileURLWithPath: "/")) {
            sourceHasGPS = (try? ImagePipeline.inspect(data))?.hasGPS ?? false
        }
        updateReviewZone()
    }

    func finishReview(title: String) {
        guard let id = reviewID else { return }
        do { try store?.update(id, title: title, hidden: currentHidden); reviewID = nil; location.discard(); refresh() }
        catch { reportStorage() }
    }

    func retry(_ id: UUID) {
        do { try store?.process(id); refresh() } catch { self.error = t(
            "Nguồn còn trên máy; xử lý lại chưa thành công.",
            "Original is retained; processing still failed."
        ) }
    }

    func deleteDraft(_ id: UUID) {
        do {
            try store?.remove(id); if reviewID == id {
                reviewID = nil
            }; refresh()
        } catch { reportStorage() }
    }

    func requestLocation(_ next: LocationPurpose) {
        guard let accountID else { profile = true; return }
        purpose = next
        if next == .nearby {
            nearbyResults = nil; nearbyBlocked = nil
        }
        location.request(accountID: accountID)
    }

    func received(_ sample: LocationSample) {
        defer { location.discard(); purpose = .review }
        location.noteReceipt(sample)
        guard sample.accountID == accountID else { return }
        let now = ProcessInfo.processInfo.systemUptime
        switch purpose {
        case .zone:
            guard sample.precise, sample.accuracy >= 0, sample.accuracy <= 50, sample.ageAtReceipt <= 60,
                  sample.coordinate.isValid
            else {
                error = t(
                    "Vị trí chưa đủ chính xác (cần chính xác, ≤50 m, mới). Chưa tạo vùng.",
                    "Location is not precise enough (needs precise, ≤50 m, fresh). Zone not created."
                ); return
            }
            changePolicy { $0.zones.append(PrivacyZone(
                name: t("Vùng riêng tư", "Private zone"),
                center: sample.coordinate
            )); $0.zonesVerified = true }
        case .nearby:
            // Addendum §4 checks Hide before Nearby without naming which one; until decided, the new-photo default
            // applies too.
            let result = PrivacyGate.evaluate(policy: policy, sample: sample, nowUptime: now)
            guard result.allowsCoordinates else { nearbyBlocked = result; return }
            do { nearbyResults = try places.nearby() } catch {
                nearbyResults = []; nearbyBlocked = nil; self.error = unavailableText
            }
        case .review:
            var effective = policy; effective.hide = reviewID == nil ? policy.hide : currentHidden
            // No frozen T_auto/T_confirm/context TTL: even an allowed sample is not turned into a Place.
            gate = PrivacyGate.evaluate(policy: effective, sample: sample, nowUptime: now)
            if let draft = reviewDraft, !draft.origin.hasPrefix("library") {
                cameraZone = CameraZoneVerdict(
                    draft: draft.id,
                    revision: policy.revision,
                    status: ZoneStatus.cameraPhoto(
                        sample: sample,
                        secondsSinceCapture: Date().timeIntervalSince(draft.createdAt),
                        policy: policy,
                        nowUptime: now
                    )
                )
                updateReviewZone()
            }
        }
    }

    func inject(_ kind: SyntheticSample) {
        guard let accountID else { return }
        let latitude: Double = kind == .inside ? 0 : kind == .edge ? 0.0018 : 0.01
        let sample = LocationSample(
            coordinate: .init(latitude: latitude, longitude: 0),
            accuracy: kind == .edge ? 20 : 10,
            ageAtReceipt: kind == .stale ? 90 : 0,
            receivedAtUptime: ProcessInfo.processInfo.systemUptime,
            precise: kind != .approximate,
            accountID: accountID
        )
        purpose = .review; received(sample)
    }

    func addZoneAtCurrentLocation() {
        requestLocation(.zone)
    }

    var unavailableText: String {
        places.scenario == .quota ? t(
            "Google hết quota. Dữ liệu trên máy vẫn còn.",
            "Google quota exhausted. Local data is retained."
        )
            : t(
                "Không tải được dữ liệu mới. Thử lại khi có mạng; dữ liệu trên máy vẫn còn.",
                "New data unavailable. Retry when connected; local data is retained."
            )
    }

    func save(_ place: PrototypePlace, label: String = "", collection: String = "") {
        guard let savedStore else { profile = true; return }
        do { try savedStore.save(placeID: place.id, userLabel: label, collection: collection); refresh() }
        catch { reportStorage() }
    }

    func unsave(_ placeID: String) {
        do { try savedStore?.remove(placeID); refresh() } catch { reportStorage() }
    }

    func setVisited(_ id: String, _ visited: Bool) {
        do { try savedStore?.setVisited(id, visited: visited); refresh() } catch { reportStorage() }
    }

    func addLink(_ text: String) -> Bool {
        do {
            guard let result = try inbox?.append(text: text, owner: owner, types: ["in-app-paste"])
            else { reportStorage(); return false }
            noticeIsError = false
            notice = result.duplicate ? t("Đã có trong Doday", "Already in Doday") : t(
                "Đã giữ liên kết · chọn địa điểm sau",
                "Link kept · choose a place later"
            )
            refresh(); return true
        } catch {
            // Shown inside the Pending sheet; nothing was saved.
            noticeIsError = true
            notice = t(
                "Chưa lưu: cần tài khoản đang hoạt động và một liên kết HTTPS hợp lệ.",
                "Not saved: an active account and a valid HTTPS link are required."
            )
            return false
        }
    }

    func deleteLink(_ item: InboxItem) {
        guard let owner else { return }
        do { try inbox?.remove(item.id, owner: owner); refresh() } catch { reportStorage() }
    }

    func resolveLink(_ item: InboxItem, with place: PrototypePlace) {
        save(place)
        if error == nil {
            deleteLink(item)
        }
    }

    func background() {
        purpose = .review; location.reset(); gate = nil; nearbyResults = nil; nearbyBlocked = nil
    }

    func recordCameraReady(_ milliseconds: Double) {
        cameraReadyMs = Array((cameraReadyMs + [milliseconds]).suffix(20))
    }
}

/// Place gating and session-bound imports; kept in this file so they can use the class's private state.
extension AppModel {
    /// Library photos are judged by their own GPS. Camera photos only by a check made within 60 s of the capture,
    /// at the current policy revision. Anything else stays uncertain while zone protection is on.
    private func updateReviewZone() {
        guard policy.zoneProtection else { reviewZone = .off; return }
        guard let draft = reviewDraft else { reviewZone = .uncertain; return }
        if draft.origin.hasPrefix("library") {
            let metadata = store.flatMap { try? Data(contentsOf: $0.sourceURL(draft.id)) }
                .flatMap { try? ImagePipeline.inspect($0) }
            reviewZone = ZoneStatus.classify(
                metadata?.coordinate,
                accuracy: metadata?.gpsAccuracy ?? LibraryPlaceCheck.assumedAccuracy,
                policy: policy
            )
        } else if let cameraZone, cameraZone.draft == draft.id, cameraZone.revision == policy.revision {
            reviewZone = cameraZone.status
        } else {
            reviewZone = .uncertain
        }
    }

    /// A library import belongs to the session that started it. Switching account or signing out cancels it, and a
    /// result that still arrives is dropped rather than saved for whoever is signed in by then.
    @discardableResult
    func importPhoto(_ load: @escaping () async throws -> Data?) -> Task<Void, Never>? {
        guard let session = owner else { profile = true; return nil }
        importTask?.cancel()
        let token = UUID()
        importToken = token; importing = true
        let task = Task {
            defer {
                if self.importToken == token {
                    self.importToken = nil; self.importing = false
                }
            }
            do {
                let bytes = try await load()
                guard !Task.isCancelled, self.importToken == token, self.owner == session, let bytes else { return }
                self.capture(bytes, origin: "library")
            } catch {
                guard !Task.isCancelled, self.importToken == token, self.owner == session else { return }
                self.error = self.t(
                    "Không đọc được ảnh được chọn; không cần cấp quyền toàn thư viện.",
                    "Could not read this selection; full library permission is not required."
                )
            }
        }
        importTask = task
        return task
    }

    private func cancelImport() {
        importTask?.cancel(); importTask = nil; importToken = nil; importing = false
    }

    // B3: evaluate only the photo's own GPS against the chosen place; the caller asks for confirmation on mismatch.
    func checkAttach(_ place: PrototypePlace) -> LibraryPlaceCheck? {
        guard let draft = reviewDraft, draft.origin.hasPrefix("library"), let url = store?.sourceURL(draft.id),
              let data = try? Data(contentsOf: url), let metadata = try? ImagePipeline.inspect(data) else { return nil }
        // Real photo GPS is never compared with canary fixture coordinates; that comparison would be meaningless.
        let comparable = draft.origin == "library-fixture" ? place.coordinate : nil
        let result = LibraryPlaceCheck.evaluate(
            photo: metadata.coordinate,
            photoAccuracy: metadata.gpsAccuracy,
            place: comparable,
            hidden: currentHidden,
            policy: policy
        )
        libraryCheck = result
        return result
    }

    /// The single gate for putting a Place on a photo: Hide and an active zone win over every choice (addendum §3.2).
    func attach(_ placeID: String?) {
        guard let id = reviewID else { return }
        if placeID != nil {
            updateReviewZone()
            guard reviewZone.allowsPlace(hidden: currentHidden) else {
                if !currentHidden {
                    error = zoneText(reviewZone)
                }
                return
            }
        }
        do { try store?.attach(id, placeID: placeID); refresh() } catch { reportStorage() }
    }
}
