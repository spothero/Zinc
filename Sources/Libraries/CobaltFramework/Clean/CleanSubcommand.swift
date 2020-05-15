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
    
    /// Global options.
    @OptionGroup() var globalOptions: Cobalt.GlobalOptions
    
    // MARK: Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.globalOptions.verbose
        
        Lumberjack.shared.log("Removing unavailable simulators...")
        
        try SimulatorController.deleteUnavailable()
        
        Lumberjack.shared.log("Cleanup complete!")
    }
}
