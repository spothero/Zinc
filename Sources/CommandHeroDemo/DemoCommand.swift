// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero

public class DemoCommand: Command {
    // MARK: Shared Instance
    
    public static let shared = DemoCommand()
    
    // MARK: Properties
    
    public static var name = "chdemo"
    public static var usageDescription = "CommandHeroDemo is a demo command for testing the CommandHero iOS framework."
    
    public static var defaultSubcommand: String? = TestSubcommand.name
    
    public static var registeredSubcommands: [Subcommand.Type] = [
        TestSubcommand.self,
    ]
}
