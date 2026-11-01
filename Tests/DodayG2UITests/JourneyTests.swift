import XCTest

/// Simulator smoke journeys with fixture data. They prove UI wiring only, not camera, field, extension or Google
/// behavior.
final class JourneyTests: XCTestCase {
    override func setUp() {
        continueAfterFailure = false
    }

    private func launch(_ extra: [String] = []) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["--g2-ui-test"] + extra
        app.launch()
        return app
    }

    private func signedIn(_ extra: [String] = []) -> XCUIApplication {
        let app = launch(extra)
        app.buttons["fixture.login"].tap()
        return app
    }

    private func type(_ text: String, into field: XCUIElement, of _: XCUIApplication) {
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        // The inline banner can shift the row mid-tap; retry until this field really has keyboard focus.
        let focused = NSPredicate(format: "hasKeyboardFocus == true")
        for _ in 0 ..< 3 where !((field.value(forKey: "hasKeyboardFocus") as? Bool) ?? false) {
            field.tap()
            _ = XCTWaiter.wait(for: [XCTNSPredicateExpectation(predicate: focused, object: field)], timeout: 2)
        }
        field.typeText(text)
    }

    private func tapAlertButton(_ app: XCUIApplication, _ id: String) {
        // Alerts over a sheet expose the action twice in the accessibility tree; either copy dismisses it.
        let button = app.buttons.matching(identifier: id).firstMatch
        XCTAssertTrue(button.waitForExistence(timeout: 5))
        button.tap()
        XCTAssertTrue(app.alerts.firstMatch.waitForNonExistence(timeout: 5))
    }

    func testFirstRunThenSignedOutCannotCaptureButMapOpens() {
        let app = launch(["--g2-onboarding"])
        XCTAssertTrue(app.buttons["onboarding.start"].waitForExistence(timeout: 5))
        app.buttons["onboarding.start"].tap()
        XCTAssertTrue(app.buttons["fixture.login"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["camera.fixture"].isEnabled)
        app.buttons["nav.map"].tap()
        XCTAssertTrue(app.textFields["map.search"].waitForExistence(timeout: 5))
    }

    func testJ1CaptureSavesWithoutTitleOrPlaceAndStaysLocal() {
        let app = signedIn()
        app.buttons["camera.fixture"].tap()
        XCTAssertTrue(app.staticTexts["state.local"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.switches["review.hide"].exists)
        app.buttons["review.done"].tap()
        app.buttons["profile.open"].tap()
        app.buttons["profile.moments"].tap()
        XCTAssertTrue(app.staticTexts["state.local"].waitForExistence(timeout: 5))
    }

    func testCameraChipHidesNextPhotoOnlyAndKeepsDefault() {
        let app = signedIn()
        app.buttons["camera.hideNext"].tap()
        app.buttons["camera.fixture"].tap()
        let hide = app.switches["review.hide"]
        XCTAssertTrue(hide.waitForExistence(timeout: 5))
        XCTAssertEqual(hide.value as? String, "0")
        app.buttons["review.done"].tap()
        app.buttons["profile.open"].tap()
        app.buttons["profile.settings"].tap()
        XCTAssertEqual(app.switches["settings.hideDefault"].value as? String, "1")
    }

    func testManualPlaceStaysBlockedWhileZoneIsUncertain() {
        let app = signedIn()
        app.buttons["camera.fixture"].tap()
        app.switches["review.hide"].setSwitch(to: "0")
        // Default zone protection with an unconfirmed zone list: choosing by hand must not attach a place.
        XCTAssertTrue(app.staticTexts["review.zone"].waitForExistence(timeout: 5))
        app.buttons["review.choosePlace"].tap()
        XCTAssertTrue(app.staticTexts["chooser.zone"].waitForExistence(timeout: 5))
        // The sheet opens at the medium detent with the manual rows below the fold; swipe its list until they show.
        let list = app.collectionViews.containing(.staticText, identifier: "chooser.zone").firstMatch
        let row = app.buttons["chooser.fixture-garden"]
        for _ in 0 ..< 4 where !row.exists {
            list.swipeUp()
        }
        XCTAssertTrue(row.waitForExistence(timeout: 5))
        XCTAssertFalse(row.isEnabled)
        row.tap()
        app.buttons["chooser.close"].tap()
        XCTAssertFalse(app.descendants(matching: .any)["review.attached"].exists)
    }

    func testDraftSurvivesTerminatedProcess() {
        let app = signedIn()
        app.buttons["camera.fixture"].tap()
        XCTAssertTrue(app.buttons["review.done"].waitForExistence(timeout: 5))
        app.terminate()
        let relaunched = launch(["--g2-keep-data"])
        relaunched.buttons["profile.open"].tap()
        relaunched.buttons["profile.moments"].tap()
        XCTAssertTrue(relaunched.staticTexts["state.local"].waitForExistence(timeout: 5))
    }

    func testJ2PastedLinkStaysPendingAndIsNotDuplicated() {
        let app = signedIn()
        app.buttons["nav.map"].tap()
        app.buttons["map.pending"].tap()
        let banner = app.staticTexts.matching(identifier: "pending.notice").firstMatch
        for expected in ["Đã giữ liên kết · chọn địa điểm sau", "Đã có trong Doday"] {
            type(
                "https://www.tiktok.com/@fixture/video/123?utm_source=copy",
                into: app.textFields["pending.url"],
                of: app
            )
            // Typing clears the previous banner and moves the Save row up. Tap after that settles, and retry a
            // missed tap; a second save is impossible because Save is disabled once the field empties.
            XCTAssertTrue(banner.waitForNonExistence(timeout: 5))
            for _ in 0 ..< 2 where !banner.exists {
                app.buttons["pending.save"].tap()
                _ = banner.waitForExistence(timeout: 5)
            }
            XCTAssertTrue(banner.exists)
            XCTAssertEqual(banner.label, expected)
        }
        XCTAssertEqual(app.staticTexts.matching(identifier: "pending.item").count, 1)
        app.buttons["pending.resolve"].tap()
        app.buttons["resolve.fixture-garden"].tap()
        XCTAssertEqual(app.staticTexts.matching(identifier: "pending.item").count, 0)
    }

    func testJ3MapWithoutCaptureSearchAndSave() {
        let app = signedIn()
        app.buttons["nav.map"].tap()
        type("Garden", into: app.textFields["map.search"], of: app)
        app.buttons["search.submit"].tap()
        let result = app.buttons["place.fixture-garden"]
        XCTAssertTrue(result.waitForExistence(timeout: 5))
        result.tap()
        app.buttons["place.save"].tap()
        XCTAssertTrue(app.buttons["place.saved"].waitForExistence(timeout: 5))
    }

    func testJ4SavedPlaceLoadsDetailsOnDemandAndOffersDirections() {
        let app = signedIn()
        app.buttons["nav.map"].tap()
        type("Garden", into: app.textFields["map.search"], of: app)
        app.buttons["search.submit"].tap()
        XCTAssertTrue(app.buttons["place.fixture-garden"].waitForExistence(timeout: 5))
        app.buttons["place.fixture-garden"].tap()
        app.buttons["place.save"].tap()
        app.buttons["place.close"].tap()
        app.buttons["map.saved"].tap()
        XCTAssertTrue(app.buttons["saved.fixture-garden"].waitForExistence(timeout: 5))
        app.buttons["saved.fixture-garden"].tap()
        XCTAssertTrue(app.buttons["place.details"].waitForExistence(timeout: 5))
        app.buttons["place.details"].tap()
        XCTAssertTrue(app.buttons["place.photos"].waitForExistence(timeout: 5))
        app.buttons["place.directions"].tap()
        tapAlertButton(app, "directions.ok")
    }

    func testPrivacyDefaultsAndZoneOffNeedsConfirmation() {
        let app = signedIn()
        app.buttons["profile.open"].tap()
        app.buttons["profile.settings"].tap()
        let hide = app.switches["settings.hideDefault"]
        XCTAssertTrue(hide.waitForExistence(timeout: 5))
        XCTAssertEqual(hide.value as? String, "1")
        XCTAssertEqual(app.switches["settings.zoneProtection"].value as? String, "1")
        XCTAssertEqual(app.switches["settings.consent"].value as? String, "0")
        let zone = app.switches["settings.zoneProtection"]
        let confirm = app.buttons["Tắt bảo vệ vùng"]
        // The inner UISwitch does not always take the synthesized tap; fall back to the switch's trailing edge.
        func flip() {
            for attempt in 0 ..< 2 {
                let inner = zone.switches.firstMatch
                if attempt == 0, inner.exists {
                    inner.tap()
                } else {
                    zone.coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
                }
                if confirm.waitForExistence(timeout: 4) {
                    return
                }
            }
            XCTFail("Zone-off confirmation did not appear")
        }
        // Cancel keeps protection on; confirming turns only zones off (DEC-31): Hide stays on, consent stays off.
        flip()
        app.alerts.buttons["Hủy"].tap()
        XCTAssertTrue(confirm.waitForNonExistence(timeout: 5))
        XCTAssertEqual(zone.value as? String, "1")
        flip()
        confirm.tap()
        XCTAssertEqual(zone.value as? String, "0")
        XCTAssertEqual(hide.value as? String, "1")
        XCTAssertEqual(app.switches["settings.consent"].value as? String, "0")
    }

    func testEnglishInterface() {
        let app = signedIn(["--g2-english"])
        XCTAssertTrue(app.buttons["nav.map"].label.contains("Map"))
        app.buttons["nav.map"].tap()
        XCTAssertTrue(app.textFields["Search a name or area"].waitForExistence(timeout: 5))
    }
}
