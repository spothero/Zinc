// Copyright © 2021 SpotHero, Inc. All rights reserved.

import XCTest
@testable import ZincFramework

final class ZincTests: XCTestCase {
    func testSuccess() {
        // This is just to get SwiftLint off my back for a bit until we add tests
        XCTAssertEqual(Zinc.configuration.commandName, "zinc")
    }
}
