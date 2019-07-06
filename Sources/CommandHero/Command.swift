// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public protocol Command {
    var defaultSubcommand: String { get }
    var registeredSubcommands: [Subcommand.Type] { get set }
    var usageDescription: String { get }

    func run(withArgs args: [String]) throws
    func run(_ key: String, withArgs args: [String]) throws
    func run(_ commandType: Subcommand.Type, withArgs args: [String]) throws
}

public extension Command {
    // MARK: Lifecycle

    func run(withArgs args: [String]) throws {
        Lumberjack.shared.debug("Processing args: \(args)")

        // The first argument should be "zinc", the package executable
        // If the args list is empty, that means we've encountered something very wrong
        guard !args.isEmpty else {
            throw CommandHeroError.unexpectedError
        }

        // Remove the first element from the array, which is our executable name -- zinc
        var args = Array(args.dropFirst())

        // Get the first element from the array, which is our command
        // If no arguments were provided, run the default command without args
        guard let commandKey = args.first else {
            try self.run(self.defaultSubcommand)
            return
        }

        // If an argument was provided but it is an option, run the default command and pass it as an arg
        guard !commandKey.starts(with: "-") else {
            try self.run(self.defaultSubcommand, withArgs: args)
            return
        }

        // Attempt to parse arg into a valid command
        // If it cannot be parsed, run the help command
        guard self.registeredSubcommands.contains(where: { $0.name == commandKey }) else {
            throw CommandHeroError.unexpectedError
        }

        // Remove the first argument again, which is the command we're going to call
        args.removeFirst()

        // Run the command!
        try self.run(commandKey, withArgs: args)
    }

    func run(_ key: String, withArgs args: [String] = []) throws {
        Lumberjack.shared.debug("Running subcommand by key '\(key)' with args: \(args)")

        guard let subcommandType = self.registeredSubcommands.first(where: { $0.name == key }) else {
            throw CommandHeroError.exception("Subcommand \(key) failed! Subcommand is not registered.")
        }

        try self.run(subcommandType, withArgs: args)
    }

    func run(_ subcommandType: Subcommand.Type, withArgs args: [String] = []) throws {
        Lumberjack.shared.debug("Running subcommand '\(subcommandType.name)' with args: \(args)")

        // try self.run(T.name, withArgs: args)

        let subcommand = subcommandType.init()
        try subcommand.run(withArgs: args)

        Lumberjack.shared.debug("Subcommand '\(subcommandType.name)' finished successfully!")
    }
}
