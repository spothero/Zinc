// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser

public struct Zinc: ParsableCommand {
    // MARK: Command Configuration
    
    public static var configuration = CommandConfiguration(
        commandName: "zinc",
        abstract: "Zinc is a command-line tool for keeping local files in sync with files hosted outside of your folder or repository.",
        shouldDisplay: false,
        subcommands: [
            LintSubcommand.self,
            SyncSubcommand.self,
        ],
        defaultSubcommand: SyncSubcommand.self,
        helpNames: .long
    )
    
    // MARK: Methods
    
    public init() {}
    
    public func run() throws {}
}
