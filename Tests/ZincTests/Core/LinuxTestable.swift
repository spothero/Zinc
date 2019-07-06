// Copyright © 2019 SpotHero, Inc. All rights reserved.

import XCTest

// Idea sourced from https://oleb.net/blog/2017/03/keeping-xctest-in-sync/

protocol LinuxTestable {
    static var allTests: [(String, (Self) -> () throws -> Void)] { get }

    func testLinuxTestSuiteIncludesAllTests()
}

extension LinuxTestable where Self: XCTestCase {
    func base_testLinuxTestSuiteIncludesAllTests() {
        #if os(macOS) || os(iOS) || os(tvOS) || os(watchOS)
            let thisClass = type(of: self)
            let linuxCount = thisClass.allTests.count
            #if swift(>=4.0)
                let darwinCount = thisClass
                    .defaultTestSuite.testCaseCount
            #else
                let darwinCount = Int(thisClass
                    .defaultTestSuite().testCaseCount)
            #endif
            XCTAssertEqual(linuxCount, darwinCount,
                           "\(darwinCount - linuxCount) tests are missing from allTests")
        #endif
    }
}
