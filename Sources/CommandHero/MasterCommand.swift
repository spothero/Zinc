
import Lumberjack

public protocol MasterCommand {
    var defaultCommand: String { get }
    var registeredCommands: [Command.Type] { get set }
    var usageDescription: String { get }

    func process(args: [String]) throws
    // mutating func register<T>(_ command: T.Type) where T: Command
    func run(_ key: String, withArgs args: [String]) throws
    func run(_ commandType: Command.Type, withArgs args: [String]) throws
}

public extension MasterCommand {
    // MARK: Properties

    // public var defaultCommand: Command
    // private var registeredCommands = [String: Command.Type]()
    // private let usageDescription: String

    // MARK: Lifecycle

    func process(args: [String]) throws {
        Lumberjack.shared.debug("Processing args: \(args)")

        // The first argument should be "zinc", the package executable
        // If the args list is empty, that means we've encountered something very wrong
        guard !args.isEmpty else {
            throw CommandHeroError.unexpectedError
        }

        // Remove the first element from the array, which is our executable name -- zinc
        var args = Array(args.dropFirst())

        // // Register Commands
        // self.registerCommands()

        // Get the first element from the array, which is our command
        // If no arguments were provided, run the default command without args
        guard let commandKey = args.first else {
            try self.run(self.defaultCommand)
            return
        }

        // If an argument was provided but it is an option, run the default command and pass it as an arg
        guard !commandKey.starts(with: "-") else {
            try self.run(self.defaultCommand, withArgs: args)
            return
        }

        // Attempt to parse arg into a valid command
        // If it cannot be parsed, run the help command
        guard self.registeredCommands.contains(where: { $0.name == commandKey }) else {
            throw CommandHeroError.unexpectedError
        }

        // Remove the first argument again, which is the command we're going to call
        args.removeFirst()

        // Run the command!
        try self.run(commandKey, withArgs: args)
    }

    // public mutating func register<T>(_ command: T.Type) where T: Command {
    //     self.registeredCommands[T.name] = command

    //     Lumberjack.shared.debug("Registered \(command) with name \(T.name).")
    // }

    func run(_ key: String, withArgs args: [String] = []) throws {
        Lumberjack.shared.debug("Running command by key '\(key)' with args: \(args)")

        guard let commandType = self.registeredCommands.first(where: { $0.name == key }) else {
            throw CommandHeroError.exception("Command \(key) failed! Command is not registered.")
        }

        try self.run(commandType, withArgs: args)
    }

    func run(_ commandType: Command.Type, withArgs args: [String] = []) throws  {
        Lumberjack.shared.debug("Running command '\(commandType.name)' with args: \(args)")

        // try self.run(T.name, withArgs: args)

        let command = commandType.init()
        try command.run(with: args)

        Lumberjack.shared.debug("Command '\(commandType.name)' finished successfully!")
    }
}