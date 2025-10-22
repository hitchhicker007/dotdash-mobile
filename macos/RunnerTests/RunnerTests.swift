import Cocoa
import FlutterMacOS
import XCTest

class RunnerTests: XCTestCase {

  func testExample() {
    let sum = addNumbers(2, 3)
    XCTAssertEqual(sum, 5, "addNumbers() should correctly add two numbers.")
  }

  func addNumbers(_ a: Int, _ b: Int) -> Int {
    return a + b
  }

  // ✅ New method: test to verify string reversal logic
  func testStringReversal() {
    let original = "Flutter"
    let reversed = reverseString(original)
    XCTAssertEqual(reversed, "rettulF", "reverseString() should correctly reverse a string.")
  }
  
  func reverseString(_ input: String) -> String {
    return String(input.reversed())
  }
}
