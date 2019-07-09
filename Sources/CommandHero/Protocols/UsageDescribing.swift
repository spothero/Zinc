// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol UsageDescribing {
    static var name: String { get }
    static var usageDescription: String { get }
    static var formattedUsageDescription: String { get }

    static func printUsageDescription()
}

public protocol SubcommandUsageDescribing: UsageDescribing {
    static var arguments: [ArgumentDescribing] { get }
    static var options: [OptionDescribing] { get }
}

public extension UsageDescribing {
    // static var arguments: [ArgumentDescribing] {
    //     return []
    // }

    // static var options: [OptionDescribing] {
    //     return []
    // }

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
        let padding = 4

        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))

        let subcommandsText = self.subcommandsText(withPadding: padding)

        var output = 
            """
            usage: \(Self.name) <subcommand> <arguments> <options>

            {bold}DESCRIPTION{reset}
            \(indentText)\(Self.usageDescription)

            {bold}SUBCOMMANDS{reset}
            \(indentText)Use \(Self.name) help <command> to read about a specific subcommand.

            \(subcommandsText)

            """

        return output
    }

    private static func subcommandsText(withPadding padding: Int) -> String {
        // Easier reference for the subcommands
        let subcommandTypes = Self.registeredSubcommands

        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))

        // Initialize the text to output in the SUBCOMMANDS section
        var subcommandsText = ""

        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = subcommandTypes.map({ $0.name.count }).max() ?? 0
        let paddedNameLength = maxNameLength + padding

        for subcommand in subcommandTypes {
            // Get the padded version of the subcommand name
            let name = subcommand.name.padded(by: paddedNameLength)

            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            subcommandsText += String(format: "%@%@%@\r\n", indentText, name, subcommand.usageDescription)
        }

        // FIXME: Implement better way of dropping final carriage return
        subcommandsText = String(subcommandsText.dropLast(2))

        return subcommandsText
    }
}

extension Mirror {
    static func reflectProperties<T>(
        of target: Any,
        matchingType type: T.Type = T.self,
        using closure: (T) -> Void
    ) {
        let mirror = Mirror(reflecting: target)

        for child in mirror.children {
            (child.value as? T).map(closure)
        }
    }
}

public extension UsageDescribing where Self: Subcommand {
    static var formattedUsageDescription: String {
        // Number of spaces to use as padding, for easy configuration
        let padding = 4

        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))

        let argumentParser = ArgumentParser(["test", "--file", "yep", "--version", "4.3", "--build", "38", "--dope"])

        guard let obj = try? self.init(from: argumentParser) else {
            return ""
        }

        let mirror = Mirror(reflecting: self)
        // print ("wow")
        // print(self.ArgumentKeys.self)

        // debugPrint(mirror)

        // debugPrint(mirror.children.count)

        for child in mirror.children {
            guard let label = child.label else {
                print("NOLABEL")
                continue
            }

            print("label: \(label), value: \(String(describing: child.value))")
        }

        let argumentsText = self.argumentsText(withPadding: padding)
        let optionsText = self.optionsText(withPadding: padding)

        var output = 
            """
            usage: \(Self.name) <arguments> <options>

            {bold}DESCRIPTION{reset}
            \(indentText)\(Self.usageDescription)

            {bold}ARGUMENTS{reset}
            \(argumentsText)

            {bold}OPTIONS{reset}
            \(optionsText)

            """

        return output
    }

    private static func argumentsText(withPadding padding: Int) -> String {
        // Easier reference for the arguments
        let arguments = Self.arguments

        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))

        // Initialize the text to output in the SUBCOMMANDS section
        var argumentsText = ""

        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = arguments.map({ $0.name.count }).max() ?? 0
        let paddedNameLength = maxNameLength + padding

        for argument in arguments {
            // Get the padded version of the subcommand name
            let name = argument.name.padded(by: paddedNameLength)

            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            argumentsText += String(format: "%@%@%@\r\n", indentText, name, argument.description ?? "")
        }

        // FIXME: Implement better way of dropping final carriage return
        argumentsText = String(argumentsText.dropLast(2))

        return argumentsText
    }

    private static func optionsText(withPadding padding: Int) -> String {
        // Easier reference for the options
        let options = Self.options

        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))

        // Initialize the text to output in the SUBCOMMANDS section
        var optionsText = ""

        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = options.map({ $0.usageDisplayName.count }).max() ?? 0
        let paddedNameLength = maxNameLength + padding

        for option in options {
            // Get the padded version of the subcommand name
            let usageDisplayName = option.usageDisplayName.padded(by: paddedNameLength)

            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            optionsText += String(format: "%@%@%@\r\n", indentText, usageDisplayName, option.description ?? "")
        }

        // FIXME: Implement better way of dropping final carriage return
        optionsText = String(optionsText.dropLast(2))

        return optionsText
    }
}

fileprivate extension String {
    func padded(by length: Int) -> String {
        return (self as NSString).padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
