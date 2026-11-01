import XCTest

/// Captures fixture-only screens for UX review. Run with TEST_RUNNER_G2_SCREENSHOTS=1 (optionally
/// TEST_RUNNER_G2_LANG=en, TEST_RUNNER_G2_SIZE=AX). Screenshots are simulator evidence, not field evidence.
final class ScreenshotTour: XCTestCase {
    private var prefix = ""

    func testTour() throws {
        let environment = ProcessInfo.processInfo.environment
        try XCTSkipUnless(environment["G2_SCREENSHOTS"] == "1", "Screenshot tour runs only on request")
        continueAfterFailure = false
        var arguments = ["--g2-ui-test", "--g2-onboarding"]
        if environment["G2_LANG"] == "en" {
            arguments.append("--g2-english")
        }
        if environment["G2_SIZE"] == "AX" {
            arguments += [
                "-UIPreferredContentSizeCategoryName",
                "UICTContentSizeCategoryAccessibilityXL",
            ]
        }
        prefix = [environment["G2_LANG"] ?? "vi", environment["G2_SIZE"] ?? "default"].joined(separator: "-")
        let app = XCUIApplication()
        app.launchArguments = arguments
        app.launch()

        XCTAssertTrue(app.buttons["onboarding.start"].waitForExistence(timeout: 10))
        shot(app, "01-onboarding")
        app.buttons["onboarding.start"].tap()
        XCTAssertTrue(app.buttons["onboarding.start"].waitForNonExistence(timeout: 5))
        shot(app, "02-camera-signed-out")
        app.buttons["fixture.login"].tap()
        shot(app, "03-camera")

        app.buttons["camera.fixture"].tap()
        XCTAssertTrue(app.buttons["review.done"].waitForExistence(timeout: 10))
        app.switches["review.hide"].setSwitch(to: "0")
        shot(app, "04-review")
        app.buttons["review.choosePlace"].tap()
        XCTAssertTrue(app.buttons["chooser.fixture-garden"].waitForExistence(timeout: 5))
        shot(app, "05-place-chooser")
        // With zone protection on and no location check, manual rows are disabled (addendum §3.2).
        app.buttons["chooser.close"].tap()
        app.buttons["review.done"].tap()

        app.buttons["nav.map"].tap()
        let search = app.textFields["map.search"]
        XCTAssertTrue(search.waitForExistence(timeout: 5))
        search.tap(); search.typeText("Garden")
        app.buttons["search.submit"].tap()
        XCTAssertTrue(app.buttons["place.fixture-garden"].waitForExistence(timeout: 5))
        shot(app, "06-map-results")
        app.buttons["place.fixture-garden"].tap()
        XCTAssertTrue(app.buttons["place.save"].waitForExistence(timeout: 5))
        app.buttons["place.save"].tap()
        shot(app, "07-bottom-sheet")
        app.buttons["place.details"].tap()
        XCTAssertTrue(app.buttons["place.photos"].waitForExistence(timeout: 5))
        shot(app, "08-details")
        app.buttons["place.close"].tap()

        app.buttons["map.saved"].tap()
        XCTAssertTrue(app.buttons["saved.fixture-garden"].waitForExistence(timeout: 5))
        shot(app, "09-saved")
        app.navigationBars.buttons.element(boundBy: app.navigationBars.buttons.count - 1).tap()

        app.buttons["map.pending"].tap()
        let field = app.textFields["pending.url"]
        XCTAssertTrue(field.waitForExistence(timeout: 5))
        field.tap(); field.typeText("https://www.instagram.com/reel/fixture/")
        app.buttons["pending.save"].tap()
        XCTAssertTrue(app.staticTexts.matching(identifier: "pending.notice").firstMatch.waitForExistence(timeout: 5))
        shot(app, "10-pending")
        app.navigationBars.buttons.element(boundBy: app.navigationBars.buttons.count - 1).tap()

        app.buttons["profile.open"].tap()
        XCTAssertTrue(app.buttons["profile.moments"].waitForExistence(timeout: 5))
        shot(app, "11-profile")
        app.buttons["profile.moments"].tap()
        shot(app, "12-journal")
        app.navigationBars.buttons.firstMatch.tap()
        app.buttons["profile.settings"].tap()
        XCTAssertTrue(app.switches["settings.hideDefault"].waitForExistence(timeout: 5))
        shot(app, "13-settings")
        app.navigationBars.buttons.firstMatch.tap()
        app.buttons["profile.lab"].tap()
        shot(app, "14-lab")
    }

    private func shot(_ app: XCUIApplication, _ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "\(prefix)-\(name)"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
