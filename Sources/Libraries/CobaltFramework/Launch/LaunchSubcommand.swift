// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser
import CarbonFramework
import Foundation

struct LaunchSubcommand: ParsableCommand {
    // MARK: Command Configuration
    
    static var configuration = CommandConfiguration(
        commandName: "launch",
        abstract: "Launches a simulator."
    )
    
    // MARK: Options
    
    /// Logs additional debug messages if enabled.
    @Flag(name: .long, help: "Logs additional debug messages if enabled.")
    private var verbose: Bool
    
    // MARK: Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.verbose
        
        let list = try SimulatorController.list()
        Lumberjack.shared.log(list)
    }
}
