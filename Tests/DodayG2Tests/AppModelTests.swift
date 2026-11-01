@testable import DodayG2
import G2Core
import XCTest

/// AppModel wiring that UI tests cannot reach reliably: zones against a Place choice, and imports that outlive the
/// session that started them. Fixture data and synthetic coordinates near 0,0 only.
@MainActor
final class AppModelTests: XCTestCase {
    private let garden = "fixture-garden"
    private var models: [AppModel] = []

    private func signedIn(_ suffix: String = "a") -> AppModel {
        let model = AppModel(arguments: ["--g2-ui-test"])
        model.login(suffix)
        models.append(model)
        return model
    }

    /// Each model wipes the shared fixture store on creation, so let image processing finish before the next test.
    override func tearDown() async throws {
        let deadline = Date().addingTimeInterval(10)
        while models.contains(where: \.processing), Date() < deadline {
            try await Task.sleep(nanoseconds: 20_000_000)
        }
        models = []
    }

    /// Opens a fresh photo for review with Hide off for it, so only the zone decides.
    private func reviewWithHideOff(_ model: AppModel, origin: String = "fixture", gps: Coordinate? = nil) {
        model.capture(AppModel.fixtureImage(gps: gps), origin: origin)
        model.currentHideChanged(false)
    }

    private func addCanaryZone(_ model: AppModel) {
        model.changePolicy {
            $0.zones = [PrivacyZone(center: Coordinate(latitude: 0, longitude: 0))]; $0.zonesVerified = true
        }
    }

    // MARK: Manual Place against zones (addendum §3.2)

    func testManualPlaceIsBlockedUntilTheCameraPhotoIsShownOutside() {
        let model = signedIn()
        reviewWithHideOff(model)
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID, "default: protection on, zone list unverified")

        addCanaryZone(model)
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID, "no location check for this photo yet")
        for kind in [SyntheticSample.inside, .edge, .approximate, .stale] {
            model.inject(kind)
            model.attach(garden)
            XCTAssertNil(model.reviewDraft?.placeID, kind.rawValue)
        }
        model.inject(.outside)
        model.attach(garden)
        XCTAssertEqual(model.reviewDraft?.placeID, garden)
    }

    func testZoneVerdictDoesNotSurviveAPolicyChange() {
        let model = signedIn()
        reviewWithHideOff(model)
        addCanaryZone(model)
        model.inject(.outside)
        XCTAssertEqual(model.reviewZone, .outside)
        model.changePolicy { _ in }
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID)
    }

    func testZoneOffLeavesHideAsTheOnlyGate() {
        let model = signedIn()
        model.changePolicy { $0.zoneProtection = false }
        model.capture(AppModel.fixtureImage(), origin: "fixture")
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID, "Hide stays on for new photos when zones are off")
        model.currentHideChanged(false)
        model.attach(garden)
        XCTAssertEqual(model.reviewDraft?.placeID, garden)
    }

    func testLibraryPhotoIsJudgedByItsOwnGPSNotTheCurrentLocation() {
        let model = signedIn()
        addCanaryZone(model)
        reviewWithHideOff(model, origin: "library-fixture", gps: Coordinate(latitude: 0, longitude: 0))
        model.inject(.outside)
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID, "photo GPS inside a zone; the phone being elsewhere now is irrelevant")

        reviewWithHideOff(model, origin: "library-fixture")
        model.attach(garden)
        XCTAssertNil(model.reviewDraft?.placeID, "no photo GPS is uncertain while protection is on")

        reviewWithHideOff(model, origin: "library-fixture", gps: Coordinate(latitude: 0.03, longitude: 0))
        model.attach(garden)
        XCTAssertEqual(model.reviewDraft?.placeID, garden)
    }

    // MARK: Library imports bound to their session

    func testImportStartedByOneAccountIsDroppedAfterSwitching() async {
        let model = signedIn("a")
        let latch = Latch()
        let bytes = AppModel.fixtureImage()
        let task = model.importPhoto {
            await latch.wait()
            return bytes
        }
        await latch.started()
        model.login("b")
        latch.open()
        await task?.value
        XCTAssertTrue(model.drafts.isEmpty, "account B must not receive a photo picked under A")
        XCTAssertFalse(model.importing)
        model.login("a")
        XCTAssertTrue(model.drafts.isEmpty, "a dropped import is not saved for A later either")
    }

    func testImportIsDroppedAfterSignOut() async {
        let model = signedIn("a")
        let latch = Latch()
        let bytes = AppModel.fixtureImage()
        let task = model.importPhoto {
            await latch.wait()
            return bytes
        }
        await latch.started()
        model.logout()
        latch.open()
        await task?.value
        model.login("a")
        XCTAssertTrue(model.drafts.isEmpty)
    }

    func testImportCompletesWithinTheSameSession() async {
        let model = signedIn("a")
        let bytes = AppModel.fixtureImage()
        await model.importPhoto { bytes }?.value
        XCTAssertEqual(model.drafts.count, 1)
        XCTAssertEqual(model.drafts.first?.origin, "library")
        XCTAssertFalse(model.importing)
    }
}

/// Holds a loader until the test releases it. It ignores cancellation on purpose, like a download that finishes
/// after the account has already changed.
@MainActor
private final class Latch {
    private var continuation: CheckedContinuation<Void, Never>?
    private var isOpen = false

    func wait() async {
        guard !isOpen else { return }
        await withCheckedContinuation { continuation = $0 }
    }

    func started() async {
        while continuation == nil {
            await Task.yield()
        }
    }

    func open() {
        isOpen = true
        continuation?.resume(); continuation = nil
    }
}
