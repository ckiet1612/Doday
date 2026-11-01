@testable import G2Core
import UIKit
import XCTest

@MainActor
final class LifecycleTests: XCTestCase {
    func testRecognitionVaultPurgesOnExpiryPolicyChangeAndBackground() {
        let vault = RecognitionVault()
        let sample = LocationSample(
            coordinate: .init(latitude: 0.01, longitude: 0),
            accuracy: 10,
            ageAtReceipt: 0,
            receivedAtUptime: 100,
            precise: true,
            accountID: "a"
        )
        vault.accept(sample, now: 100)
        XCTAssertNotNil(vault.current(now: 159))
        XCTAssertNil(vault.current(now: 160))
        vault.accept(sample, now: 100)
        vault.discard()
        XCTAssertNil(vault.current(now: 101))
    }

    func testSavedIntentStoresOnlyIDsUserLabelsAndUserStatusPerAccount() throws {
        let root = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        defer { try? FileManager.default.removeItem(at: root) }
        let store = try SavedStore(root: root, accountID: "a")
        try store.save(placeID: "fixture-garden", userLabel: "Weekend", collection: "Ideas")
        try store.setVisited("fixture-garden", visited: true)
        let reopened = try SavedStore(root: root, accountID: "a")
        XCTAssertEqual(try reopened.list().first?.userLabel, "Weekend")
        XCTAssertEqual(try reopened.list().first?.visited, true)
        XCTAssertTrue(try SavedStore(root: root, accountID: "b").list().isEmpty)
    }

    func testRealNSItemProviderURLAndTextPaths() async throws {
        let url = try NSItemProvider(object: XCTUnwrap(URL(string: "https://example.com/test")) as NSURL)
        let value = try await ItemProviderReader.read(url)
        XCTAssertEqual(value.type, "public.url")
        XCTAssertTrue(value.text.contains("example.com"))
        let text = NSItemProvider(object: "Look https://www.tiktok.com/@fixture/video/123" as NSString)
        let textValue = try await ItemProviderReader.read(text)
        XCTAssertEqual(textValue.type, "public.plain-text")
        XCTAssertFalse(textValue.registeredTypes.isEmpty)
        // Some sources register public.url but deliver raw bytes.
        let raw = NSItemProvider()
        raw.registerDataRepresentation(forTypeIdentifier: "public.url", visibility: .all) { completion in
            completion(Data("https://www.instagram.com/reel/fixture/".utf8), nil); return nil
        }
        let rawValue = try await ItemProviderReader.read(raw)
        XCTAssertEqual(rawValue.type, "public.url")
        XCTAssertTrue(rawValue.text.contains("instagram.com"))
        let unsupported = NSItemProvider(object: "no link here" as NSString)
        do { _ = try await ItemProviderReader.read(unsupported); XCTFail("text without HTTPS must not be accepted")
        } catch {}
        XCTAssertThrowsError(try SharePayload.parse("https://user:password@example.com/test"))
    }

    func testCanaryMatrixContainsAtLeast100PrivacyCasesAndPassiveSequences() {
        var cases = 0
        for account in ["a", "b"] {
            for hide in [true, false] {
                for consent in [true, false] {
                    for zonesOn in [true, false] {
                        for latitude in [0.0, 0.0018, 0.01] {
                            for accuracy in [10.0, 60.0] {
                                for precise in [true, false] {
                                    let policy = PrivacyPolicy(
                                        accountID: account,
                                        revision: 1,
                                        hide: hide,
                                        zoneProtection: zonesOn,
                                        zonesVerified: true,
                                        externalConsent: consent,
                                        zones: [
                                            .init(center: .init(latitude: 0, longitude: 0), radius: 200),
                                            .init(
                                                center: .init(latitude: 0.02, longitude: 0),
                                                radius: 200
                                            ),
                                        ]
                                    )
                                    let sample = LocationSample(
                                        coordinate: .init(latitude: latitude, longitude: 0),
                                        accuracy: accuracy,
                                        ageAtReceipt: 0,
                                        receivedAtUptime: 100,
                                        precise: precise,
                                        accountID: account
                                    )
                                    let allowed = PrivacyGate.evaluate(policy: policy, sample: sample, nowUptime: 101)
                                        .allowsCoordinates
                                    let expected = !hide && consent && precise && accuracy <= 50 &&
                                        (!zonesOn || latitude == 0.01)
                                    XCTAssertEqual(allowed, expected)
                                    cases += 1
                                }
                            }
                        }
                    }
                }
            }
        }
        XCTAssertEqual(cases, 192)
        for _ in 0 ..< 100 {
            for event in [APITrigger.appOpen, .cameraOpen, .capture, .save, .mapOpen, .pan, .zoom] {
                XCTAssertNil(TriggerPolicy.request(for: event))
            }
        }
    }
}
