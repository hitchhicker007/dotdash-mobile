import Cocoa
import FlutterMacOS
import XCTest

class RunnerTests: XCTestCase {

  func testExample() {
    // Example test: verify that a simple function works correctly.
    let sum = addNumbers(2, 3)
    XCTAssertEqual(sum, 5, "addNumbers() should correctly add two numbers.")
  }

  // Example helper function
  func addNumbers(_ a: Int, _ b: Int) -> Int {
    return a + b
  }
}
