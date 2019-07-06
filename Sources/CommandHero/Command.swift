// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol Command {
    // associatedtype Options = CommandOptions

    static var name: String { get }
    static var usageDescription: String { get }

//    var description: String
//    func describe()
//    func run(with options: Options) throws

    init()
    // func run(with args: [String]) throws
    // func run(with context: CommandContext) throws
    func run(with parser: ArgumentParser) throws
}

public extension Command {
    func run(with args: [String]) throws {
        let parser = ArgumentParser(args)
        // let context = CommandContext(arguments: [], options: [:], parser: parser, subcommand: Self.name)
        // let context = CommandContext(arguments: [], options: [:], parser: parser)

        let help: Bool = try parser.get("--help")

        try self.run(with: parser)
    }
}

// extension Command {
//    private func options(from args: [String]) -> Options  {
//
//    }
//
//    func run(with args: [String]) {
//
//    }
// }
