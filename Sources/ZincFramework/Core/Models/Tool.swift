// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public struct Tool: Codable {
    public enum VerifiedCommand: String {
        case brew
        case mint
        case ruby
        case rvm
        case swift
    }
    
    public let command: String
    public let subcommand: String
    public let version: String
    
    public var verifiedCommand: VerifiedCommand? {
        return VerifiedCommand(rawValue: self.command)
    }
}
