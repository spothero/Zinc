// Copyright © 2020 SpotHero, Inc. All rights reserved.

import ArgumentParser
import CarbonFramework

struct AuditSubcommand: ParsableCommand {
    // MARK: Command Configuration
    
    static var configuration = CommandConfiguration(
        commandName: "audit",
        abstract: "Audits installed commands, project dependencies, and remote files to alert the user of any changes."
    )
    
    // MARK: Options
    
    /// The Zincfile to parse.
    @Option(name: .shortAndLong, default: "Zincfile", help: "The Zincfile to parse and audit.")
    private var file: String
    
    /// Logs additional debug messages if enabled.
    @Flag(name: .long, help: "Logs additional debug messages if enabled.")
    private var verbose: Bool
    
    // MARK: - Methods
    
    func run() throws {
        Lumberjack.shared.isDebugEnabled = self.verbose
        
        try self.audit(self.file)
    }
    
    private func audit(_ filename: String? = nil) throws {
        guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
            return
        }
        
        // Audit all tools in the file first
        ToolAuditor.audit(zincfile.tools)
        
        // TODO: Audit package managed dependencies
        
        // TODO: Audit remote files
    }
}
