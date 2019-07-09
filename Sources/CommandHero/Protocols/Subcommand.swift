// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public protocol Subcommand: SubcommandUsageDescribing {
    static var name: String { get }

    init(from parser: ArgumentParser) throws

    func run() throws
}
