// Copyright © 2020 SpotHero, Inc. All rights reserved.

public protocol Command: UsageDescribing {
    static var defaultSubcommand: String? { get }
    static var registeredSubcommands: [Subcommand.Type] { get set }
    
    func run(withArgs args: [String]) throws
    func run(_ key: String, withArgs args: [String]) throws
    func run(_ subcommandType: Subcommand.Type, withArgs args: [String]) throws
}

public extension Command {
    func run(withArgs args: [String] = CommandLine.arguments) throws {
        CommandHero.logger.debug("Processing args: \(args)")
        
        // The first argument should be the name of the package excutable
        // If the args list is empty, that means we've encountered something very wrong
        guard !args.isEmpty else {
            throw CommandHeroError.exception("Command not found!")
        }
        
        // Remove the first element from the array, which is our executable name
        var args = Array(args.dropFirst())
        
        // Get the first element from the array, which is our command
        // If no arguments were provided, run the default command without args
        guard let firstArgument = args.first else {
            // If a default subcommand exists, run it, otherwise print usage description
            if let defaultSubcommand = Self.defaultSubcommand {
                try self.run(defaultSubcommand)
            } else {
                Self.printUsageDescription()
            }
            
            return
        }
        
        // Don't continue if the first argument is "help"
        guard firstArgument != "help" else {
            // If there is an additional argument, print usage description for the subcommand, otherwise print it for this command
            if args.indices.contains(1) {
                try self.run(args[1], withArgs: ["--help"])
            } else {
                Self.printUsageDescription()
            }
            
            return
        }
        
        // If the first argument is --help, -help, or -h, print usage description for this command
        guard !Constants.helpFlags.contains(firstArgument) else {
            Self.printUsageDescription()
            
            return
        }
        
        // Don't continue if the first argument is an option
        guard !firstArgument.starts(with: "-") else {
            // If a default subcommand exists, pass the first argument into it and run it, otherwise print usage description
            if let defaultSubcommand = Self.defaultSubcommand {
                try self.run(defaultSubcommand, withArgs: args)
            } else {
                Self.printUsageDescription()
            }
            
            return
        }
        
        // Attempt to parse arg into a valid subcommand
        // If it cannot be parsed, run the help subcommand
        guard Self.registeredSubcommands.contains(where: { $0.name == firstArgument }) else {
            throw CommandHeroError.exception("Unable to parse arguments into valid subcommand!")
        }
        
        // Remove the first argument again, which is the subcommand we're going to call
        args.removeFirst()
        
        // Run the subcommand!
        try self.run(firstArgument, withArgs: args)
    }
    
    func run(_ key: String, withArgs args: [String] = []) throws {
        CommandHero.logger.debug("Running subcommand by key '\(key)' with args: \(args)")
        
        guard let subcommandType = Self.registeredSubcommands.first(where: { $0.name == key }) else {
            throw CommandHeroError.exception("Subcommand \(key) failed! Subcommand is not registered.")
        }
        
        try self.run(subcommandType, withArgs: args)
    }
    
    func run(_ subcommandType: Subcommand.Type, withArgs args: [String] = []) throws {
        CommandHero.logger.debug("Running subcommand '\(subcommandType.name)' with args: \(args)")
        
        let parser = ArgumentParser(args)
        let shouldDescribeUsage = try parser.exists(Constants.helpFlags)
        
        guard !shouldDescribeUsage else {
            subcommandType.printUsageDescription()
            return
        }
        
        let subcommand = try subcommandType.init(from: parser)
        
        try subcommand.run()
        
        CommandHero.logger.debug("Subcommand '\(subcommandType.name)' finished successfully!")
    }
}
