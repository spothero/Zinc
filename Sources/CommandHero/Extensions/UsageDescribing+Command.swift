// Copyright © 2020 SpotHero, Inc. All rights reserved.

public extension UsageDescribing where Self: Command {
    static var formattedUsageDescription: String {
        // Number of spaces to use as padding, for easy configuration
        let padding = 4
        
        // Padding to be used at the start of every line in each section
        let indentText = String(Array(repeating: " ", count: padding))
        
        let subcommandsText = self.subcommandsText(withPadding: padding)
        
        let output =
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
        let maxNameLength = subcommandTypes.map { $0.name.count }.max() ?? 0
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
