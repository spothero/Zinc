// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack
import Yams

public class Zinc: MasterCommand {
    // MARK: Shared Instance

    public static let shared = Zinc()

    // MARK: Constants

    // MARK: Properties

    public var defaultCommand = SyncCommand.name
    public var registeredCommands: [Command.Type] = [
        HelpCommand.self,
        TestCommand.self,
        SyncCommand.self,
    ]
    public var usageDescription = "This is what that tool is for."

    // // MARK: Lifecycle

    // public func process(args: [String]) {
    //     Lumberjack.shared.debug("Processing args: \(args)")

    //     // The first argument should be "zinc", the package executable
    //     // If the args list is empty, that means we've encountered something very wrong
    //     guard !args.isEmpty else {
    //         Lumberjack.shared.report(ZincError.unexpectedError)
    //         return
    //     }

    //     // Remove the first element from the array, which is our executable name -- zinc
    //     var args = Array(args.dropFirst())

    //     // Register Commands
    //     self.register(HelpCommand.self)
    //     self.register(TestCommand.self)
    //     self.register(SyncCommand.self)

    //     // Get the first element from the array, which is our command
    //     // If no arguments were provided, run the default command without args
    //     guard let commandKey = args.first else {
    //         self.run(self.defaultCommand)
    //         return
    //     }

    //     // If an argument was provided but it is an option, run the default command and pass it as an arg
    //     guard !commandKey.starts(with: "-") else {
    //         self.run(self.defaultCommand, withArgs: args)
    //         return
    //     }

    //     // Attempt to parse arg into a valid command
    //     // If it cannot be parsed, run the help command
    //     guard self.registeredCommands.keys.contains(commandKey) else {
    //         Lumberjack.shared.report(ZincError.invalidCommand(commandKey))
    //         self.run(HelpCommand.self)
    //         return
    //     }

    //     // Remove the first argument again, which is the command we're going to call
    //     args.removeFirst()

    //     // Run the command!
    //     self.run(commandKey, withArgs: args)
    // }

    // private func register<T>(_ command: T.Type) where T: Command {
    //     self.registeredCommands[T.name] = command

    //     Lumberjack.shared.debug("Registered \(command) with name \(T.name).")
    // }

    // private func run<T>(_ command: T.Type, withArgs args: [String] = []) where T: Command {
    //     self.run(T.name, withArgs: args)
    // }

    // private func run(_ key: String, withArgs args: [String] = []) {
    //     Lumberjack.shared.debug("Running command '\(key)' with args: \(args)")

    //     guard let commandType = self.registeredCommands[key] else {
    //         Lumberjack.shared.report("Command \(key) failed! Command is not registered.")
    //         return
    //     }

    //     do {
    //         let command = commandType.init()
    //         try command.run(with: args)

    //         Lumberjack.shared.debug("Command \(key) finished successfully!")
    //     } catch {
    //         Lumberjack.shared.report(error, message: "Command \(key) failed!")
    //     }
    // }
}
