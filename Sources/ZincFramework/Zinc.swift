// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack
import Yams

public class Zinc: Command {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Properties

    public var defaultSubcommand = SyncSubcommand.name

    public var registeredSubcommands: [Subcommand.Type] = [
        HelpSubcommand.self,
        TestSubcommand.self,
        SyncSubcommand.self,
    ]

    public var usageDescription = "This is what that tool is for."
}
