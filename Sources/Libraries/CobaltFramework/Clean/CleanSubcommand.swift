// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser
import CarbonFramework
import Foundation

struct CleanSubcommand: ParsableCommand {
    // MARK: Command Configuration
    
    static var configuration = CommandConfiguration(
        commandName: "clean",
        abstract: "Removes all unavailable simulators."
    )
    
    // MARK: Options
    
    /// Logs additional debug messages if enabled.
    @Flag(name: .long, help: "Logs additional debug messages if enabled.")
    private var verbose: Bool
    
    // MARK: Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.verbose
        
        Lumberjack.shared.log("Removing unavailable simulators...")
        
        try SimulatorController.deleteUnavailable()
        
        Lumberjack.shared.log("Cleanup complete!")
    }
}
