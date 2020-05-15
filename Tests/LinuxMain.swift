import XCTest

import CarbonTests
import ZincTests

var tests = [XCTestCaseEntry]()
tests += CarbonTests.__allTests()
tests += ZincTests.__allTests()

XCTMain(tests)
