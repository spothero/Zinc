// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CarbonFramework
@testable import CobaltFramework
import XCTest

final class SimulatorParsingTests: XCTestCase {
    func testParsingJSON() throws {
        guard let json = FileClerk.shared.readRelativeFile("../MockData/simulator_list.json") else {
            XCTFail("JSON file could not be read.")
            return
        }
        
        do {
            try SimulatorController.parseListJSON(json)
        } catch {
            Lumberjack.shared.report(error)
        }
    }
}
