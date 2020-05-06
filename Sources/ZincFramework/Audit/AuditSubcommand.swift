// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import FileHero
import Lumberjack
import ShellRunner

class AuditSubcommand: Subcommand {
    // MARK: - Properties
    
    // MARK: Command Metadata
    
    static var name = "audit"
    static var usageDescription = "Audits installed commands, project dependencies, and remote files to alert the user of any changes."
    static var arguments: [ArgumentDescribing] = []
    static var options: [OptionDescribing] = [Options.file, Options.isVerbose]
    
    // MARK: Options
    
    struct Options {
        static let file = Option<String>("file", shortName: "f", description: "The Zincfile to use. Will default to the Zincfile in the root if left unspecified.")
        static let isVerbose = Option<Bool>("verbose", defaultValue: false, description: "Logs additional debug messages if enabled.")
    }
    
    private let isVerbose: Bool
    private let file: String?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    required init(from parser: ArgumentParser) throws {
        self.file = try parser.valueIfPresent(for: Options.file)
        self.isVerbose = try parser.value(for: Options.isVerbose)
    }
    
    // MARK: Subcommand
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.isVerbose
        
        try self.audit(self.file)
    }
    
    // MARK: Utilities
    
    private func audit(_ filename: String? = nil) throws {
        guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
            return
        }
        
        // Audit all tools in the file first
        ToolAuditor.audit(zincfile.tools)
        
        // Audit package managed dependencies
        
        // Audit remote files
    }
}
