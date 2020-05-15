// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser
import CarbonFramework
import Foundation

struct ListSubcommand: ParsableCommand {
    // MARK: Command Configuration
    
    static var configuration = CommandConfiguration(
        commandName: "list",
        abstract: "Lists all simulator devices, device types, and runtimes available."
    )
    
    // MARK: Enums
    
    private enum Filter: String, ExpressibleByArgument {
        case all
        case devices
        case deviceTypes = "devicetypes"
        case runtimes
        case pairs
    }
    
    // MARK: Options
    
    /// Global options.
    @OptionGroup() var globalOptions: Cobalt.GlobalOptions
    
    /// Allows filtering of specific list output.
    @Option(default: .all, help: "Allows filtering of specific list output.")
    private var filter: Filter
    
    /// Logs additional debug messages if enabled.
    @Flag(help: "Prints out the list as JSON")
    private var json: Bool
    
    // MARK: Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.globalOptions.verbose
        
        if self.json {
            let list = try SimulatorController.listJSON()
            Lumberjack.shared.log(list, options: .prettyPrint)
        } else {
            let list = try SimulatorController.listRaw()
            Lumberjack.shared.log(list)
        }
    }
}
