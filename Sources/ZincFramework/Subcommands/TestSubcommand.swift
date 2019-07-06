// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack

class TestSubcommand: Subcommand {
    // MARK: - Properties

    // MARK: Command Metadata

    public static var name = "test"
    public static var usageDescription = "This is the usage description for the test subcommand."

    // MARK: Arguments

    private let name: String

    // MARK: Options

    private let file: String
    private let version: Double
    private let build: Int
    private let isDope: Bool

    // MARK: - Methods

    // MARK: Initializers

    public required init(from parser: ArgumentParser) throws {
        self.name = try parser.valueForArgument(atIndex: 0)

        self.file = try parser.valueForOption(withName: "file", shortName: "f")
        self.version = try parser.valueForOption(withName: "version", shortName: "v")
        self.build = try parser.valueForOption(withName: "build", shortName: "b")
        self.isDope = try parser.valueForOption(withName: "dope", shortName: "d")
    }

    // MARK: Subcommand

    public func run() throws {
        Lumberjack.shared.log([self.file, self.version, self.build, self.isDope])
    }
}
