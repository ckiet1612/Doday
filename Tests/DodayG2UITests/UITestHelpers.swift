import XCTest

extension XCUIElement {
    /// Synthesized taps do not always reach SwiftUI's inner UISwitch; retry with the trailing edge until the value
    /// changes.
    func setSwitch(to value: String) {
        XCTAssertTrue(waitForExistence(timeout: 5))
        for attempt in 0 ..< 3 where (self.value as? String) != value {
            let inner = switches.firstMatch
            if attempt == 0, inner.exists {
                inner.tap()
            } else {
                coordinate(withNormalizedOffset: CGVector(dx: 0.93, dy: 0.5)).tap()
            }
            let changed = XCTNSPredicateExpectation(predicate: NSPredicate(format: "value == %@", value), object: self)
            _ = XCTWaiter.wait(for: [changed], timeout: 2)
        }
        XCTAssertEqual(self.value as? String, value)
    }
}
