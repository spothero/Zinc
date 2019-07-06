// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack
import Yams

public class Zinc: MasterCommand {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Properties

    public var defaultCommand = SyncCommand.name

    public var registeredCommands: [Command.Type] = [
        HelpCommand.self,
        TestCommand.self,
        SyncCommand.self,
    ]

    public var usageDescription = "This is what that tool is for."
}
