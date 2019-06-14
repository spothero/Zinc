// Copyright © 2019 SpotHero. All rights reserved.

import XCTest
import ZincTests

extension ZincTestCase {
    static var allTests: [(String, (ZincTestCase) -> () throws -> Void)] = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
    ]
}

extension ZincTests {
    static var allTests: [(String, (ZincTests) -> () throws -> Void)] = [
        ("testLinuxTestSuiteIncludesAllTests", testLinuxTestSuiteIncludesAllTests),
        ("testRunning", testRunning),
    ]
}

XCTMain([
    testCase(ZincTests.allTests),
])
