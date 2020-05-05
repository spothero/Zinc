// Copyright © 2020 SpotHero, Inc. All rights reserved.

public extension UsageDescribing where Self: Subcommand {
    static var formattedUsageDescription: String {
        // Number of spaces to use as padding, for easy configuration
        let padding = 4
        
        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))
        
        let argumentsText = arguments.map { "<\($0.name)>" }.joined(separator: " ")
        let argumentsListTest = self.argumentsListTest(withPadding: padding)
        let optionsListText = self.optionsListText(withPadding: padding)
        
        let output =
            """
            {bold}USAGE{reset}
            \(indentText)\(Self.name) \(argumentsText) <options>
            
            {bold}DESCRIPTION{reset}
            \(indentText)\(Self.usageDescription)
            
            {bold}ARGUMENTS{reset}
            \(argumentsListTest)
            
            {bold}OPTIONS{reset}
            \(optionsListText)
            
            """
        
        return output
    }
    
    private static func argumentsListTest(withPadding padding: Int) -> String {
        // Easier reference for the arguments
        let arguments = Self.arguments
        
        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))
        
        // Initialize the text to output in the SUBCOMMANDS section
        var argumentsListText = ""
        
        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = arguments.map { $0.name.count }.max() ?? 0
        let paddedNameLength = maxNameLength + padding
        
        for argument in arguments.sorted(by: { $0.index < $1.index }) {
            // Get the padded version of the subcommand name
            let name = argument.name.padded(by: paddedNameLength)
            
            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            argumentsListText += String(format: "%@%@%@\r\n", indentText, name, argument.description ?? "")
        }
        
        // FIXME: Implement better way of dropping final carriage return
        argumentsListText = String(argumentsListText.dropLast(2))
        
        return argumentsListText
    }
    
    private static func optionsListText(withPadding padding: Int) -> String {
        // Easier reference for the options
        let options = Self.options
        
        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))
        
        // Initialize the text to output in the SUBCOMMANDS section
        var optionsListText = ""
        
        // Get the maximum name length, then add 4 spaces to get the padded name length
        let maxNameLength = options.map { $0.usageDisplayName.count }.max() ?? 0
        let paddedNameLength = maxNameLength + padding
        
        for option in options {
            // Get the padded version of the subcommand name
            let usageDisplayName = option.usageDisplayName.padded(by: paddedNameLength)
            
            // Add the line to the subcommand text, formatted for output and with no whitespace (since they are already factored in)
            optionsListText += String(format: "%@%@%@\r\n", indentText, usageDisplayName, option.description ?? "")
        }
        
        // FIXME: Implement better way of dropping final carriage return
        optionsListText = String(optionsListText.dropLast(2))
        
        return optionsListText
    }
}
