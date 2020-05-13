// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack
import Yams

public final class Zinc: Command {
    // MARK: Shared Instance
    
    public static let shared = Zinc()
    
    // MARK: Properties
    
    public static var name = "zinc"
    public static var usageDescription =
        "Zinc is a command-line tool for keeping local files in sync with files hosted outside of your folder or repository."
    
    public static var defaultSubcommand: String? = SyncSubcommand.name
    
    public static var registeredSubcommands: [Subcommand.Type] = [
        SyncSubcommand.self,
        AuditSubcommand.self,
    ]
}
