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
    
    /// Global options.
    @OptionGroup() var globalOptions: Cobalt.GlobalOptions
    
    // MARK: Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.globalOptions.verbose
    }
}
