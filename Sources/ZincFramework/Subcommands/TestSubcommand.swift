// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack

class TestSubcommand: Subcommand {
    public static var name = "test"
    public static var usageDescription = "This is the usage description for the test subcommand."

    public required init() {}

    public func run(withParser parser: ArgumentParser) throws {
        let file: String = try parser.get("--file", "-f", type: String.self)
        let version: Double = try parser.get("--version", "-v", type: Double.self)
        let build: Int = try parser.get("--build", "-v", type: Int.self)
        let isDope: Bool = try parser.get("--dope", "-d", type: Bool.self)

        Lumberjack.shared.log([file, version, build, isDope])
    }
}
