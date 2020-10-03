import XCTest
@testable import Firefly

final class FireflyTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Firefly().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
