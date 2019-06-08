// Copyright © 2019 SpotHero. All rights reserved.

import Foundation
import Utility
import Yams

public class Zinc {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Constants

    private static let usageDescription = "This is what that tool is for."

    // MARK: Enums

    public enum CommandKey: String {
        case help
        case lint
        case sync
        case testColors = "test-colors"

        static let `default`: CommandKey = .sync
    }

    private var registeredCommands = [CommandKey: (Command, ArgumentParser)]()

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
        var args = Array(args.dropFirst())

        let parser = ArgumentParser(usage: "<options>", overview: Zinc.usageDescription)

        self.register(.help, toCommand: HelpCommand(), withParser: parser)
        self.register(.lint, toCommand: LintCommand(), withParser: parser)
        self.register(.sync, toCommand: SyncCommand(), withParser: parser)
        
        do {
            let parsedArguments = try parser.parse(args)
            
        //    debugPrint(parsedArguments)
        } catch {
            Lumberjack.shared.report(error)
        }

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

    private func register<T>(_ key: CommandKey, toCommand command: T, withParser parser: ArgumentParser) 
        -> ArgumentParser where T : Command {
        registeredCommands[key] = (command, parser)
        
        return parser.add(subparser: key.rawValue, overview: T.usageDescription)
    }

    public func run(_ key: CommandKey, withArgs args: [String] = []) {
        Lumberjack.shared.debug("Running command '\(key.rawValue)' with args: \(args)")

        guard let (command, parser) = self.registeredCommands[key] else {
            Lumberjack.shared.report("Command \(key.rawValue) failed!")
            return
        }

        do {
            try command.run(with: args, parser: parser)

            Lumberjack.shared.debug("Command \(key.rawValue) finished successfully!")
        } catch {
            Lumberjack.shared.report(error, message: "Command \(key.rawValue) failed!")
        }
    }
}
