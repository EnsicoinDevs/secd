import XCTest

import secdTests

var tests = [XCTestCaseEntry]()
tests += secdTests.allTests()
XCTMain(tests)
