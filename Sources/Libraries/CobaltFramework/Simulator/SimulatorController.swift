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
        return try self.parseListJSON(json)
    }
    
//    static func listBooted() -> String {
//        return self.run("xcrun simctl list | booted")
//    }
    
    static func cleanup() throws {
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
    
    static func parseListJSON(_ json: String) throws -> SimulatorList {
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

// # TODO: Ensure xcrun is installed
// # xcrun is installed via xcode-select --install, which requires popup confirmation
// # After a user has installed, they can re-run this script. We should prompt them to re-run and exit.
//
// # TODO: Check for a booted device, you can use "booted"
//
// # display booted devices:
// # xcrun simctl list | grep Booted
//
// # for swift command-line app:
// # xcrun simctl list --json
//
// echo "Creating simulator device..."
// UUID=$(xcrun simctl create MySimulatorDevice com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro com.apple.CoreSimulator.SimRuntime.iOS-13-4)
// echo "Simulator device created with UUID '$UUID'."
//
// echo "Booting device..."
// xcrun simctl boot $UUID
// echo "Device booted."
//
// XCODE_PATH=$(xcode-select --print-path)
//
// echo "Launching Simulator.app..."
// open "$XCODE_PATH"
//
// # TODO: When finished, run simctl shutdown and erase. Maybe this is where the Swift command line tool can hang until complete?
// # If we decide to hang, it should be an optional property to pass in
//
// # TODO: Cleanup? xcrun simctl delete unavailable
