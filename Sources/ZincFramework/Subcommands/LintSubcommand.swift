// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import FileHero
import Lumberjack
import ShellRunner

class LintSubcommand: Subcommand {
    // MARK: - Properties

    // MARK: Command Metadata

    public static var name = "lint"
    public static var usageDescription = "Performs basic linting against a Zincfile to identify issues and errors."
    public static var arguments: [ArgumentDescribing] = []
    public static var options: [OptionDescribing] = []

    // MARK: Options

    private let file: String?

    // MARK: - Methods

    // MARK: Initializers

    public required init(from parser: ArgumentParser) throws {
        self.file = try parser.valueIfPresent(forOption: "file", shortName: "f")
    }

    // MARK: Subcommand

    public func run() throws {
        try self.lint(self.file)
    }

    // MARK: Utilities

    public func lint(_ filename: String? = nil) throws {
        guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
            return
        }

        Lumberjack.shared.log("\(String(describing: zincfile.filename)) linted successfully.")
    }
}
