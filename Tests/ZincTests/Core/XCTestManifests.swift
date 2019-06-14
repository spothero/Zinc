// Copyright © 2019 SpotHero. All rights reserved.

import XCTest

#if !canImport(ObjectiveC)
    public func allTests() -> [XCTestCaseEntry] {
        return [
            testCase(ZincTests.allTests),
        ]
    }
#endif
