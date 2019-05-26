// Copyright © 2019 SpotHero. All rights reserved.

import Foundation
import Yams

public class Zinc {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Enums

    public enum Command: String {
        case help
        case lint
        case sync
        case testColors = "test-colors"

        static let `default`: Command = .sync
    }

    // MARK: Lifecycle

    public func process(args: [String]) {
        Lumberjack.shared.debug("Processing args: \(args)")

        // The first argument should be "zinc", the package executable
        // If the args list is empty, that means we've encountered something very wrong
        guard !args.isEmpty else {
            Lumberjack.shared.report(ZincError.unexpectedError)
            return
        }

        // Remove the first element from the array, which is our executable name -- zinc
        var args = args
        args.removeFirst()

        // Get the first element from the array, which is our command
        // If no command is passed in, use the default command (specified in the Command enum)

        // Get the first argument if one was provided, otherwise run the default command
        guard let firstArg = args.first else {
            self.run(.default)
            return
        }

        // Attempt to parse arg into a valid command
        // If it cannot be parsed, run the help command
        guard let command = Command(rawValue: firstArg) else {
            Lumberjack.shared.report(ZincError.invalidCommand(firstArg))
            self.run(.help)
            return
        }

        // Remove the first argument again, which is the command we're going to call
        args.removeFirst()

        // Run the command!
        self.run(command, withArgs: args)
    }

    public func run(_ command: Command, withArgs args: [String] = []) {
        Lumberjack.shared.debug("Running command '\(command.rawValue)' with args: \(args)")

        do {
            switch command {
            case .help:
                try HelpCommand().run()
            case .lint:
                try LintCommand().run()
            case .sync:
                try SyncCommand().run()
            case .testColors:
                Lumberjack.shared.testColors()
            }

            Lumberjack.shared.debug("Command \(command.rawValue) finished successfully!")
        } catch {
            Lumberjack.shared.report(error, message: "Command \(command.rawValue) failed!")
        }
    }
}
