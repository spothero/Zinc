// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Lumberjack
import ShellRunner

class ToolAuditor {
    static func audit(_ tools: [Tool]) {
        Lumberjack.shared.debug("Auditing \(tools.count) tools...")
        
        for tool in tools {
            do {
                try self.audit(tool)
            } catch {
                Lumberjack.shared.report(error, message: "Error auditing command '\(tool.command)'.")
            }
        }
    }
    
    static func audit(_ tool: Tool) throws {
        // TODO: Check for output of "command not found: \(tool.command)"
        
        if let supportedTool = tool.supportedTool {
            try self.audit(supportedTool, forVersion: tool.version)
        } else {
            // TODO: It should be possible to execute this using the method below as well. Is that better than .contains?
            let output = ShellRunner.shared.bash("\(tool.command) \(tool.subcommand)")
            output.contains(tool.version)
        }
        
//        if auditResult {
//            Lumberjack.shared.debug("\(tool.command): v\(tool.version)")
//        } else {
//            Lumberjack.shared.report("\(tool.command) at version \(tool.version) successfully.")
//        }
    }
    
    // TODO: Should this even bother returning a Bool?
    @discardableResult
    static func audit(_ tool: Tool.SupportedTool, forVersion version: String) throws -> Bool {
        // Get the shell command to run
        let command = "\(tool.defaultCommand) \(tool.defaultSubcommand)"
        
        Lumberjack.shared.debug("Running command '\(command)'...")
        
        // Get the output from running the command in bash
        let output = ShellRunner.shared.bash(command)
        
        Lumberjack.shared.debug(output)
        
        // Validate that a version matching the tool's regex pattern was returned
        // If it wasn't, throw an error
        guard let installedVersion = output.firstMatch(for: tool.regexPattern) else {
            throw AuditError.invalidRegexPattern
        }
        
        // Validate the installed version versus the version that Zinc expected
        // If they don't match, throw an error
        guard installedVersion == version else {
            throw AuditError.invalidVersion(expectedVersion: version, installedVersion: installedVersion)
        }
        
        return true
    }
}

public enum AuditError: Error {
    case invalidRegexPattern
    case invalidVersion(expectedVersion: String, installedVersion: String)
}

extension AuditError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRegexPattern:
            return "Invalid regex pattern for validated command!"
        case let .invalidVersion(expectedVersion, installedVersion):
            return "Expected version \(expectedVersion) but found \(installedVersion)."
        }
    }
}

private extension String {
//    func matches(_ regex: String) -> Bool {
//        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
//    }
    
    func matches(for pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern)
            let results = regex.matches(in: self,
                                        range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    func firstMatch(for pattern: String) -> String? {
        return self.matches(for: pattern).first
    }
}
