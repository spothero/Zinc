// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack
import Yams

public class Zinc: Command {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Properties

    public static var defaultSubcommand: String? = SyncSubcommand.name

    public static var registeredSubcommands: [Subcommand.Type] = [
        TestSubcommand.self,
        SyncSubcommand.self,
    ]

    public static var usageDescription = "This is the usage description for the zinc command."
}
