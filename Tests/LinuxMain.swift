import XCTest

import CarbonTests
import CobaltTests
import ZincTests

var tests = [XCTestCaseEntry]()
tests += CarbonTests.__allTests()
tests += CobaltTests.__allTests()
tests += ZincTests.__allTests()

XCTMain(tests)
