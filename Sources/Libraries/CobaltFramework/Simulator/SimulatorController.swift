// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CarbonFramework
import Foundation

class SimulatorController {
    // TODO: Add LocalizedError
    enum Error: Swift.Error {
        case cannotParseData
        case noOutput
    }
    
    static func list() throws -> SimulatorList {
        let json = try self.run("xcrun simctl list --json")
        return try self.parseSimulatorListJSON(json)
    }
    
//    static func listBooted() -> String {
//        return self.run("xcrun simctl list | booted")
//    }
    
    static func deleteUnavailable() throws {
        try self.run("xcrun simctl delete unavailable")
    }
    
    static func boot(_ uuid: String) throws {
        try self.run("xcrun simctl boot \(uuid)")
    }
    
    static func launchSimulator() throws {
        let xcodePath = try self.run("xcode-select --print-path")
        let simulatorAppPath = "\(xcodePath)/Applications/Simulator.app/"
        
        try self.run("open \(simulatorAppPath)")
    }
    
    static func parseSimulatorListJSON(_ json: String) throws -> SimulatorList {
        guard let jsonData = json.data(using: .utf8) else {
            throw Error.cannotParseData
        }
        
        let decoder = JSONDecoder()
        
        return try decoder.decode(SimulatorList.self, from: jsonData)
    }
    
    @discardableResult
    private static func run(_ command: String) throws -> String {
        do {
            let output = try ShellRunner.shared.run(command)
            return output
        } catch {
            Lumberjack.shared.report(error)
            throw Error.noOutput
        }
    }
}
