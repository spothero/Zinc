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
        
        if let command = tool.verifiedCommand {
            try self.audit(command, forVersion: tool.version)
        } else {
            let output = ShellRunner.shared.bash("\(tool.command) \(tool.subcommand)")
            output.contains(tool.version)
        }
        
//        if auditResult {
//            Lumberjack.shared.debug("\(tool.command): v\(tool.version)")
//        } else {
//            Lumberjack.shared.report("\(tool.command) at version \(tool.version) successfully.")
//        }
    }
    
    @discardableResult
    static func audit(_ command: Tool.VerifiedCommand, forVersion version: String) throws -> Bool {
        // TODO: Make this cleaner for all commands, don't duplicate logic
        
        switch command {
        case .brew:
            let output = ShellRunner.shared.bash("brew --version")
            
            // The output format of brew --version is:
            //
            // Homebrew <VERSION>
            // Homebrew/homebrew-core (git revision <REVISION>; last commit <DATE>)
            
            guard let installedVersion = output.firstMatch(for: #"(?<=^Homebrew )[0-9]+\.[0-9]+\.[0-9]+"#) else {
                throw AuditError.invalidRegexPattern
            }
            
            guard installedVersion == version else {
                throw AuditError.invalidVersion(expectedVersion: version, installedVersion: installedVersion)
            }
            
            return true
        case .mint:
            return false
        case .ruby:
            return false
        case .rvm:
            return false
        case .swift:
            return false
        }
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
