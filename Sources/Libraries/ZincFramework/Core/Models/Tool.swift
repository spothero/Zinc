// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CarbonFramework
import Foundation

public struct Tool: Codable {
    /// Regex pattern matching a semantic version string
    private static let semanticVersionPattern: String = #"[0-9]+\.[0-9]+\.[0-9]+"#
    
    public let command: String
    public let subcommand: String?
    public let version: String
    
    /// Returns an enum representing a tool supported by Zinc for improved validation.
    public var supportedTool: SupportedTool? {
        return SupportedTool(command: self.command)
    }
    
    /// The regex pattern to match against when validating the version of the tool.
    ///
    /// Note: This type cannot be a `StaticString` due to the requirement of using `NSRegularExpression`.
    public var regexPattern: String {
        return self.supportedTool?.regexPattern ?? Self.semanticVersionPattern
    }
}

extension Tool {
    public enum SupportedTool: String, CaseIterable {
        case bundler
        case homebrew
        case mint
        case ruby
        case rvm
        case swift
        
        /// The default command for the tool. Defaults to the rawValue of the enum.
        public var defaultCommand: String {
            switch self {
            case .homebrew:
                return "brew"
            default:
                return self.rawValue
            }
        }
        
        /// The default subcommand, argument, or options to run to return the version of the tool.
        public var defaultSubcommand: String {
            switch self {
            case .bundler,
                 .homebrew,
                 .mint,
                 .ruby,
                 .rvm,
                 .swift:
                return "--version"
            }
        }
        
        /// The regex pattern to match against when validating the version of the tool.
        ///
        /// Note: This type cannot be a `StaticString` due to the requirement of using `NSRegularExpression`.
        public var regexPattern: String {
            switch self {
            case .bundler:
                return #"(?<=^Bundler version )[0-9]+\.[0-9]+\.[0-9]+"#
            case .homebrew:
                return #"(?<=^Homebrew )[0-9]+\.[0-9]+\.[0-9]+"#
            case .mint:
                return #"(?<=^Version: )[0-9]+\.[0-9]+\.[0-9]+"#
            case .ruby:
                return #"(?<=^ruby )[0-9]+\.[0-9]+\.[0-9]+"#
            case .rvm:
                return #"(?<=^rvm )[0-9]+\.[0-9]+\.[0-9]+"#
            case .swift:
                return #"(?<=^Apple Swift version )[0-9]+\.[0-9]+\.[0-9]+"#
            }
        }
        
        public init?(command: String) {
            // Find the first tool with the default command that matches the command passed in and return it if it exists
            // If no matching tool is found, fall back on the default initializer
            // This is useful to allow both "homebrew" and "brew" to match the same supported tool
            if let matchingTool = Self.allCases.first(where: { $0.defaultCommand.lowercased() == command.lowercased() }) {
                self = matchingTool
            } else {
                self.init(rawValue: command)
            }
        }
    }
}
