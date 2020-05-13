import XCTest

import CommandHeroTests
import ZincTests

var tests = [XCTestCaseEntry]()
tests += CommandHeroTests.__allTests()
tests += ZincTests.__allTests()

XCTMain(tests)
