// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public protocol Subcommand: UsageDescribing {
    static var name: String { get }

    init()
    func run(withParser parser: ArgumentParser) throws
}

public extension Subcommand {
    func run(withArgs args: [String]) throws {
        let parser = ArgumentParser(args)

        let shouldDescribeUsage = try parser.exists(Constants.helpFlags)

        guard !shouldDescribeUsage else {
            self.printUsageDescription()
            return
        }

        try self.run(withParser: parser)
    }
}
