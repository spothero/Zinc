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

    private let name: String?

    // MARK: Options

    private let file: String?
    private let version: Double?
    private let build: Int?
    private let isDope: Bool

    // MARK: - Methods

    // MARK: Initializers

    public required init(from parser: ArgumentParser) throws {
        self.name = try parser.value(forArgumentAtIndex: 0)

        self.file = try parser.valueIfPresent(forOption: "file", shortName: "f")
        self.version = try parser.valueIfPresent(forOption: "version", shortName: "v")
        self.build = try parser.valueIfPresent(forOption: "build", shortName: "b")
        self.isDope = try parser.value(forOption: "dope", shortName: "d", defaultValue: false)
    }

    // MARK: Subcommand

    public func run() throws {
        Lumberjack.shared.log([
            String(describing: self.name),
            String(describing: self.file),
            String(describing: self.version),
            String(describing: self.build),
            self.isDope,
        ])
    }
}
