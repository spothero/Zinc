// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser

public struct Cobalt: ParsableCommand {
    // MARK: Command Configuration
    
    public static var configuration = CommandConfiguration(
        commandName: "cobalt",
        abstract: "Cobalt helps with evaluating and launching Xcode simulators for a specific project.",
        shouldDisplay: false,
        subcommands: [
            LaunchSubcommand.self,
        ],
        defaultSubcommand: LaunchSubcommand.self,
        helpNames: .long
    )
    
    // MARK: Methods
    
    public init() {}
    
    public func run() throws {}
}
