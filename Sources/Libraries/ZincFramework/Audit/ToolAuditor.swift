// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CarbonFramework
import Foundation

class ToolAuditor {
    static func audit(_ tools: [Tool]) {
        Lumberjack.shared.log("Auditing \(tools.count) tools...")
        
        var errorCount = 0
        
        for tool in tools {
            do {
                try self.audit(tool)
            } catch {
                errorCount += 1
                Lumberjack.shared.report(error, message: "Error auditing command '\(tool.command)'.")
            }
        }
        
        guard errorCount == 0 else {
            return
        }
        
        Lumberjack.shared.success("Audit completed. No violations found!")
    }
    
    static func audit(_ tool: Tool) throws {
        // TODO: Check for output of "command not found: \(tool.command)"
        
        if let supportedTool = tool.supportedTool {
            try self.audit(supportedTool, forVersion: tool.version)
        } else {
            if let subcommand = tool.subcommand {
                // TODO: It should be possible to execute this using the method below as well. Is that better than .contains?
                let output = try ShellRunner.shared.run("\(tool.command) \(subcommand)")
                let hasVersion = output.contains(tool.version)
                
                if !hasVersion {
                    throw AuditError.invalidVersion(expectedVersion: tool.version, installedVersion: "Unknown")
                }
            } else {
                throw AuditError.missingSubcommand(command: tool.command)
            }
        }
    }
    
    // TODO: Should this even bother returning a Bool?
    @discardableResult
    static func audit(_ tool: Tool.SupportedTool, forVersion version: String) throws -> Bool {
        // Get the shell command to run
        let command = "\(tool.defaultCommand) \(tool.defaultSubcommand)"
        
        Lumberjack.shared.debug("Running command '\(command)'...")
        
        // Get the output from running the command in bash
        let output = try ShellRunner.shared.run(command)
        
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
    case missingSubcommand(command: String)
}

extension AuditError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidRegexPattern:
            return "Invalid regex pattern for validated command!"
        case let .invalidVersion(expectedVersion, installedVersion):
            return "Expected version \(expectedVersion) but found \(installedVersion)."
        case let .missingSubcommand(command):
            return "Missing subcommand for command '\(command)'."
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
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                // swiftlint:disable:next force_unwrapping
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
