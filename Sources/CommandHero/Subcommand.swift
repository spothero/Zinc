// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public protocol Subcommand {
    static var name: String { get }
    static var usageDescription: String { get }

    init()
    func run(withParser parser: ArgumentParser) throws
}

public extension Subcommand {
    func run(withArgs args: [String]) throws {
        let parser = ArgumentParser(args)

        let shouldPrintUsage = try parser.exists("--help")

        guard !shouldPrintUsage else {
            Lumberjack.shared.debug("wow")
            return
        }

        try self.run(withParser: parser)
    }
}
