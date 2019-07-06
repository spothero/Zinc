// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol Subcommand {
    static var name: String { get }
    static var usageDescription: String { get }

    init()
    func run(with parser: ArgumentParser) throws
}

public extension Subcommand {
    func run(with args: [String]) throws {
        let parser = ArgumentParser(args)
        let help: Bool = try parser.get("--help")

        try self.run(with: parser)
    }
}
