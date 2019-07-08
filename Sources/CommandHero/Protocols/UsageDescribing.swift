// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol UsageDescribing {
    static var name: String { get }
    static var usageDescription: String { get }
    static var formattedUsageDescription: String { get }

    static func printUsageDescription()
}

public extension UsageDescribing {
    static var formattedUsageDescription: String {
        return "\(Self.name): \(Self.usageDescription)"
    }

    static func printUsageDescription() {
        UsageDescriber.shared.printUsageDescription(for: self)
    }
}

public extension UsageDescribing where Self: Command {
    static var formattedUsageDescription: String {
        // Number of spaces to use as padding, for easy configuration
        let paddingSpaces = 4

        // Padding to be used at the start of every line in each section
        let leadingPadding = String(Array(repeating: " ", count: paddingSpaces))

        // Easier reference for the subcommands
        let subcommandTypes = Self.registeredSubcommands

        // Initialize the text to output in the SUBCOMMANDS section
        var subcommandText = ""

        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = subcommandTypes.map({ $0.name.count }).max() ?? 0
        let paddedNameLength = maxNameLength + paddingSpaces

        for subcommand in subcommandTypes {
            // Get the padded version of the subcommand name
            let name = subcommand.name.padded(by: paddedNameLength)

            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            subcommandText += String(format: "%@%@%@\r\n", leadingPadding, name, subcommand.usageDescription)
        }

        return 
            """
            usage: zinc <subcommand> <arguments> <options>

            {bold}DESCRIPTION{reset}
            \(leadingPadding)\(Self.usageDescription)

            {bold}SUBCOMMANDS{reset}
            \(subcommandText)
               
            """
    }
}

fileprivate extension String {
    func padded(by length: Int) -> String {
        return (self as NSString).padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
