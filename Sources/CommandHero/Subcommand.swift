// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol Subcommand {
    static var name: String { get }
    static var usageDescription: String { get }

    init()
    func run(withParser parser: ArgumentParser) throws
}

public extension Subcommand {
    func run(withArgs args: [String]) throws {
        let parser = ArgumentParser(args)
        let help: Bool = try parser.get("--help")

        try self.run(withParser: parser)
    }
}
