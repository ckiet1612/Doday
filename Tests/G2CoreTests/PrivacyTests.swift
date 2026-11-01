@testable import G2Core
import XCTest

final class PrivacyTests: XCTestCase {
    let account = "fixture-account-a"
    let center = Coordinate(latitude: 0, longitude: 0)

    func policy(
        hide: Bool = false,
        zonesOn: Bool = true,
        consent: Bool = true,
        verified: Bool = true,
        revision: Int = 1
    ) -> PrivacyPolicy {
        PrivacyPolicy(
            accountID: account,
            revision: revision,
            hide: hide,
            zoneProtection: zonesOn,
            zonesVerified: verified,
            externalConsent: consent,
            zones: [PrivacyZone(center: center, radius: 200)]
        )
    }

    func sample(
        _ latitude: Double = 0.01,
        accuracy: Double = 10,
        age: TimeInterval = 0,
        received: TimeInterval = 100
    ) -> LocationSample {
        LocationSample(
            coordinate: Coordinate(latitude: latitude, longitude: 0),
            accuracy: accuracy,
            ageAtReceipt: age,
            receivedAtUptime: received,
            precise: true,
            accountID: account
        )
    }

    func testDefaultConfigurationCannotSendCoordinates() {
        let result = PrivacyGate.evaluate(
            policy: .safeDefault(accountID: account),
            sample: sample(),
            nowUptime: 101
        )
        XCTAssertFalse(result.allowsCoordinates)
    }

    func testErrorCircleTouchingZoneIsBlocked() {
        let result = PrivacyGate.evaluate(policy: policy(), sample: sample(0.0018, accuracy: 20), nowUptime: 101)
        XCTAssertFalse(result.allowsCoordinates)
    }

    func testOutsideWithIndependentConsentAndHideOffCanSend() {
        XCTAssertTrue(PrivacyGate.evaluate(policy: policy(), sample: sample(), nowUptime: 101).allowsCoordinates)
    }

    func testZoneOffDoesNotOverrideHideOrConsent() {
        XCTAssertFalse(PrivacyGate.evaluate(
            policy: policy(hide: true, zonesOn: false),
            sample: sample(),
            nowUptime: 101
        ).allowsCoordinates)
        XCTAssertFalse(PrivacyGate.evaluate(
            policy: policy(zonesOn: false, consent: false),
            sample: sample(),
            nowUptime: 101
        ).allowsCoordinates)
    }

    func testRetentionExpiresAtSixtyAndDoesNotResetOnRetry() {
        XCTAssertTrue(PrivacyGate.evaluate(policy: policy(), sample: sample(), nowUptime: 159).allowsCoordinates)
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: sample(), nowUptime: 160).allowsCoordinates)
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: sample(), nowUptime: 161).allowsCoordinates)
    }

    func testMissingStaleApproximateInvalidAndCrossAccountSamplesFailClosed() {
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: nil, nowUptime: 101).allowsCoordinates)
        for input in [sample(age: 61), sample(accuracy: -1), sample(accuracy: 51), sample(.nan)] {
            XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: input, nowUptime: 101).allowsCoordinates)
        }
        var approximate = sample()
        approximate.precise = false
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: approximate, nowUptime: 101).allowsCoordinates)
        var other = sample()
        other.accountID = "fixture-account-b"
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(), sample: other, nowUptime: 101).allowsCoordinates)
    }

    func testRevisionToggleAndAccountChangeInvalidateLateResult() {
        let ticket = RecognitionTicket(accountID: account, revision: 1, issuedAtUptime: 100)
        XCTAssertTrue(ticket.isCurrent(policy: policy(), sample: sample(), nowUptime: 101))
        XCTAssertFalse(ticket.isCurrent(policy: policy(revision: 2), sample: sample(), nowUptime: 101))
        XCTAssertFalse(ticket.isCurrent(policy: policy(hide: true), sample: sample(), nowUptime: 101))
        XCTAssertFalse(ticket.isCurrent(
            policy: .safeDefault(accountID: "fixture-account-b"),
            sample: sample(),
            nowUptime: 101
        ))
    }

    func testUnverifiedZonesAndInvalidRadiusFailClosed() {
        XCTAssertFalse(PrivacyGate.evaluate(policy: policy(verified: false), sample: sample(), nowUptime: 101)
            .allowsCoordinates)
        var input = policy()
        input.zones = [PrivacyZone(center: center, radius: 99)]
        XCTAssertFalse(PrivacyGate.evaluate(policy: input, sample: sample(), nowUptime: 101).allowsCoordinates)
    }

    func testPassiveEventsNeverHavePlacesRequest() {
        for event in [APITrigger.appOpen, .cameraOpen, .capture, .save, .mapOpen, .pan, .zoom] {
            XCTAssertNil(TriggerPolicy.request(for: event))
        }
    }

    func testPhotosAndReviewsNeedDistinctExplicitTriggers() {
        XCTAssertFalse(TriggerPolicy.request(for: .details)?.fields.contains("photos") ?? true)
        XCTAssertFalse(TriggerPolicy.request(for: .details)?.fields.contains("reviews") ?? true)
        XCTAssertEqual(TriggerPolicy.request(for: .viewPhotos)?.fields, ["id", "photos", "attributions"])
        XCTAssertEqual(TriggerPolicy.request(for: .viewReviews)?.fields, ["id", "reviews", "attributions"])
    }

    func testNoAutoAssignmentWithoutFrozenCalibration() {
        XCTAssertEqual(AssignmentPolicy.decide(score: 1, runnerUp: 0, calibration: nil), .unassigned)
        let thresholds = Calibration(auto: 0.95, confirm: 0.6, contextTTL: 20, version: "fixture-only")
        XCTAssertEqual(AssignmentPolicy.decide(score: 0.96, runnerUp: 0.9, calibration: thresholds), .confirm)
        XCTAssertEqual(AssignmentPolicy.decide(score: 0.99, runnerUp: 0.1, calibration: thresholds), .automatic)
    }

    func testMapsURLHasDestinationIDAndNeverOrigin() throws {
        let url = try XCTUnwrap(MapLinks.directions(placeID: "fixture-id", label: "A & B"))
        let parts = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        XCTAssertEqual(parts.queryItems?.first { $0.name == "destination_place_id" }?.value, "fixture-id")
        XCTAssertFalse(parts.queryItems?.contains { $0.name == "origin" } ?? true)
    }

    func testLibraryMismatchUsesPhotoGPSAgainstAttachedPlaceOnlyWhenNotBlocked() {
        let photo = Coordinate(latitude: 0.03, longitude: 0)
        let near = Coordinate(latitude: 0.0305, longitude: 0)
        let far = Coordinate(latitude: 0.01, longitude: 0)
        let open = policy(zonesOn: false)
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: nil, photoAccuracy: nil, place: far, hidden: false, policy: open),
            .noPhotoGPS
        )
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: photo, photoAccuracy: nil, place: near, hidden: false, policy: open),
            .consistent
        )
        guard case let .mismatch(meters) = LibraryPlaceCheck.evaluate(
            photo: photo,
            photoAccuracy: nil,
            place: far,
            hidden: false,
            policy: open
        )
        else { return XCTFail("expected mismatch") }
        XCTAssertGreaterThan(meters, 1000)
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: photo, photoAccuracy: nil, place: nil, hidden: false, policy: open),
            .placeWithoutCoordinate
        )
        // Hide on this photo, an unverified zone list, or a photo inside/near an active zone never feed the warning.
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: photo, photoAccuracy: nil, place: far, hidden: true, policy: open),
            .blocked
        )
        XCTAssertEqual(
            LibraryPlaceCheck
                .evaluate(photo: photo, photoAccuracy: nil, place: far, hidden: false, policy: policy(verified: false)),
            .blocked
        )
        var zoned = policy()
        zoned.zones = [PrivacyZone(center: Coordinate(latitude: 0.0317, longitude: 0), radius: 150)]
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: photo, photoAccuracy: nil, place: far, hidden: false, policy: zoned),
            .blocked
        )
        XCTAssertEqual(
            LibraryPlaceCheck.evaluate(photo: photo, photoAccuracy: 10, place: far, hidden: false, policy: zoned),
            .mismatch(meters: photo.distance(to: far))
        )
    }

    func testZoneStatusClassifiesAPhotoAndFailsClosed() {
        let zoned = policy()
        XCTAssertEqual(ZoneStatus.classify(center, accuracy: 10, policy: zoned), .inside)
        // About 200.15 m from the centre: outside the 200 m radius, but a 20 m error circle still touches it.
        XCTAssertEqual(
            ZoneStatus.classify(Coordinate(latitude: 0.0018, longitude: 0), accuracy: 20, policy: zoned),
            .uncertain
        )
        XCTAssertEqual(
            ZoneStatus.classify(Coordinate(latitude: 0.01, longitude: 0), accuracy: 10, policy: zoned),
            .outside
        )
        XCTAssertEqual(ZoneStatus.classify(nil, accuracy: 10, policy: zoned), .uncertain)
        XCTAssertEqual(ZoneStatus.classify(center, accuracy: .nan, policy: zoned), .uncertain)
        XCTAssertEqual(
            ZoneStatus.classify(
                Coordinate(latitude: 0.01, longitude: 0),
                accuracy: 10,
                policy: policy(verified: false)
            ),
            .uncertain
        )
        XCTAssertEqual(ZoneStatus.classify(center, accuracy: 10, policy: policy(zonesOn: false)), .off)
    }

    func testChoosingAPlaceNeverBypassesHideOrAnActiveZone() {
        XCTAssertTrue(ZoneStatus.off.allowsPlace(hidden: false))
        XCTAssertTrue(ZoneStatus.outside.allowsPlace(hidden: false))
        XCTAssertFalse(ZoneStatus.inside.allowsPlace(hidden: false))
        XCTAssertFalse(ZoneStatus.uncertain.allowsPlace(hidden: false))
        for status in [ZoneStatus.off, .outside, .inside, .uncertain] {
            XCTAssertFalse(status.allowsPlace(hidden: true), status.rawValue)
        }
    }

    func testCameraPhotoZoneNeedsAReliableSampleWithinSixtySecondsOfCapture() {
        let zoned = policy()
        func zone(_ sample: LocationSample, after seconds: TimeInterval, policy: PrivacyPolicy? = nil) -> ZoneStatus {
            ZoneStatus.cameraPhoto(
                sample: sample,
                secondsSinceCapture: seconds,
                policy: policy ?? zoned,
                nowUptime: 101
            )
        }
        XCTAssertEqual(zone(sample(), after: 5), .outside)
        XCTAssertEqual(zone(sample(0), after: 5), .inside)
        // A check made later only says where the phone is now, not where the photo was taken.
        XCTAssertEqual(zone(sample(), after: 61), .uncertain)
        XCTAssertEqual(zone(sample(), after: -1), .uncertain)
        XCTAssertEqual(zone(sample(accuracy: 80), after: 5), .uncertain)
        XCTAssertEqual(zone(sample(age: 70), after: 5), .uncertain)
        var otherAccount = sample()
        otherAccount.accountID = "fixture-account-b"
        XCTAssertEqual(zone(otherAccount, after: 5), .uncertain)
        // Consent and Hide belong to recognition and attach; the zone verdict itself does not depend on them.
        XCTAssertEqual(zone(sample(), after: 5, policy: policy(hide: true, consent: false)), .outside)
        XCTAssertEqual(zone(sample(0), after: 600, policy: policy(zonesOn: false)), .off)
    }
}
