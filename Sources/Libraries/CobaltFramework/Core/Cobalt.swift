// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser
import CarbonFramework

public struct Cobalt: ParsableCommand {
    // MARK: Command Configuration
    
    public static var configuration = CommandConfiguration(
        commandName: "cobalt",
        abstract: "Cobalt helps with evaluating and launching Xcode simulators for a specific project.",
        shouldDisplay: false,
        subcommands: [
            CleanSubcommand.self,
            LaunchSubcommand.self,
            ListSubcommand.self,
        ],
        defaultSubcommand: LaunchSubcommand.self,
        helpNames: .long
    )
    
    // MARK: Global Options
    
    struct GlobalOptions: ParsableArguments {
        /// Logs additional debug messages if enabled.
        @Flag(name: .long, help: "Logs additional debug messages if enabled.")
        var verbose: Bool
    }
    
    // MARK: Methods
    
    public init() {}
    
    public func run() throws {}
}
