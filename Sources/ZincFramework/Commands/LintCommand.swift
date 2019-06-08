// Copyright © 2019 SpotHero. All rights reserved.

import Foundation
import Utility

class LintCommand: Command {
    // typealias Options = CommandOptions
    
    static var usageDescription: String {
        return "This command is the lint command."
    }
    
    func run(with options: Options) throws {
        self.lint()
    }
    
    func run(with args: [String], parser: ArgumentParser) throws {
        let parser = parser.add(subparser: "lint", overview: "Lints the file.")
        // let parser = ArgumentParser(usage: "<options>", overview: "This is what this tool is for")
        let file: OptionArgument<String> = parser.add(option: "--file", shortName: "-f", kind: String.self, usage: "The filename to parse.")
        
        do {
            let parsedArguments = try parser.parse(args)

            if let filename = parsedArguments.get(file) {
                Lumberjack.shared.log("Your file is \(filename)")
            }
        } catch {
            Lumberjack.shared.report(error)
        }

    }
    
    public func lint(_ filename: String? = nil) {
        do {
            guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
                return
            }
            
            Lumberjack.shared.log("\(String(describing: zincfile.filename)) linted successfully.")
        } catch {
            Lumberjack.shared.report(error, message: "Unable to lint Zincfile.")
        }
    }
}

// struct LintOptions: CommandOptions {
//     let file: String?
    
//     let fileOption = Option<String>(key: "file",
//                                     abbreviation: "f",
//                                     usage: "Specifies the Zincfile to parse.",
//                                     isRequired: true)
    
//     func parse(_ arguments: [String]) {
//         // self.file = arguments.
//     }
// }

// class ArgumentParser {
//     static let shared = ArgumentParser()

//     static func parse(_ arguments: [String]) {
//         for argument in arguments {
//             // identify the type of argument

//         }
//     }
// }

protocol CommandOptions {
    // func parse(_ arguments: [String])
}

// //protocol CommandOption {
// //    var key: String { get }
// //    var abbreviation: String? { get }
// //    var description: String { get }
// //    var defaultValue: T? { get }
// //}

// struct Argument {
//     let key: String
//     let value: String
// }

// enum ArgumentType {
//     case option(key: String, value: String)
//     case flag(key: String)
//     case value(_ value: String)
// }

// struct Option<T> {
//     let key: String
//     let abbreviation: Character?
//     let defaultValue: T?
//     let usage: String
//     let isRequired: Bool
    
//     var value: T?
    
//     init(key: String,
//          abbreviation: Character? = nil,
//          usage: String,
//          defaultValue: T? = nil,
//          isRequired: Bool = false) {
//         self.key = key
//         self.abbreviation = abbreviation
//         self.usage = usage
//         self.defaultValue = defaultValue
//         self.isRequired = isRequired
//     }
// }
