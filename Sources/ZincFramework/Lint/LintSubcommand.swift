// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import FileHero
import Lumberjack
import ShellRunner

class LintSubcommand: Subcommand {
    // MARK: - Properties
    
    // MARK: Command Metadata
    
    static var name = "lint"
    static var usageDescription = "Performs basic linting against a Zincfile to identify issues and errors."
    static var arguments: [ArgumentDescribing] = []
    static var options: [OptionDescribing] = []
    
    // MARK: Options
    
    private let file: String?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    required init(from parser: ArgumentParser) throws {
        self.file = try parser.valueIfPresent(forOption: "file", shortName: "f")
    }
    
    // MARK: Subcommand
    
    func run() throws {
        try self.lint(self.file)
    }
    
    // MARK: Utilities
    
    func lint(_ filename: String? = nil) throws {
        guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
            return
        }
        
        Lumberjack.shared.log("\(String(describing: zincfile.filename)) linted successfully.")
    }
}
