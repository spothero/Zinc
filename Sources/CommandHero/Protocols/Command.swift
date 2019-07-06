// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public protocol Command: UsageDescribing {
    static var defaultSubcommand: String? { get }
    static var registeredSubcommands: [Subcommand.Type] { get set }

    func run(withArgs args: [String]) throws
    func run(_ key: String, withArgs args: [String]) throws
    func run(_ subcommandType: Subcommand.Type, withArgs args: [String]) throws
}

public extension Command {
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
        guard let firstArgument = args.first else {
            // If a default subcommand exists, run it, otherwise print usage description
            if let defaultSubcommand = Self.defaultSubcommand {
                try self.run(defaultSubcommand)
            } else {
                self.printUsageDescription()
            }
            
            return
        }

        // Don't continue if the first argument is "help"
        guard firstArgument != "help" else {
            // If there is an additional argument, print usage description for the subcommand, otherwise print it for this command
            if args.indices.contains(1) {
                try self.run(args[1], withArgs: ["--help"])
            } else {
                self.printUsageDescription()
            }

            return
        }

        // If the first argument is --help, -help, or -h, print usage description for this command
        guard !Constants.helpFlags.contains(firstArgument) else {
            self.printUsageDescription()

            return
        }

        // Don't continue if the first argument is an option
        guard !firstArgument.starts(with: "-") else {
            // If a default subcommand exists, pass the first argument into it and run it, otherwise print usage description
            if let defaultSubcommand = Self.defaultSubcommand {
                try self.run(defaultSubcommand, withArgs: args)
            } else {
                self.printUsageDescription()
            }
            
            return
        }

        // Attempt to parse arg into a valid subcommand
        // If it cannot be parsed, run the help subcommand
        guard Self.registeredSubcommands.contains(where: { $0.name == firstArgument }) else {
            throw CommandHeroError.unexpectedError
        }

        // Remove the first argument again, which is the subcommand we're going to call
        args.removeFirst()

        // Run the subcommand!
        try self.run(firstArgument, withArgs: args)
    }

    func run(_ key: String, withArgs args: [String] = []) throws {
        Lumberjack.shared.debug("Running subcommand by key '\(key)' with args: \(args)")

        guard let subcommandType = Self.registeredSubcommands.first(where: { $0.name == key }) else {
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
