// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

class TestCommand: Command {
//     typealias Options = TestOptions

    static var name = "test"
    static var usageDescription = "This command is the test command."

//    func run(with options: Options) throws {
    ////        self.lint()
//    }

    required init() {}

    func run(with args: [String]) throws {
        let parser = ArgumentParser(args)

        let file: String = try parser.get("--file", "-f", type: String.self)
        let version: Double = try parser.get("--version", "-v", type: Double.self)
        let build: Int = try parser.get("--build", "-v", type: Int.self)
        let isDope: Bool = try parser.get("--dope", "-d", type: Bool.self)
//        let path: String? = try parser.get("--path", "-p", type: String.self)

        Lumberjack.shared.log([file, version, build, isDope])
//
        ////        let parser = parser
//        let file = parser.add(option: "--file", shortName: "-f", kind: String.self, usage: nil, completion: nil)
//        let version = parser.add(option: "--version", shortName: "-v", kind: Int.self, usage: nil, completion: nil)
//
//        do {
//            let result = try parser.get(args)
//
//            Lumberjack.shared.log(result)
//        } catch {
//            Lumberjack.shared.report(String(describing: error))
//        }
    }
}

protocol ValidArgument {
    static var hasExplicitValue: Bool { get }

    static var implicitValue: ValidArgument { get }

//    init(argument: String) throws
}

extension ValidArgument {
    static var hasExplicitValue: Bool {
        return true
    }

    static var implicitValue: ValidArgument {
        return ""
    }
}

extension String: ValidArgument {
    public init(argument: String) throws {
        self = argument
    }
}

extension Int: ValidArgument {
    public init(argument: String) throws {
        guard let int = Int(argument) else {
            throw ArgumentParser.Error.typeMismatch
//            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int.self)
        }

        self = int
    }
}

extension Double: ValidArgument {
    public init(argument: String) throws {
        guard let double = Double(argument) else {
            throw ArgumentParser.Error.typeMismatch
//            throw ArgumentConversionError.typeMismatch(value: argument, expectedType: Int.self)
        }

        self = double
    }
}

extension Bool: ValidArgument {
    static var hasExplicitValue: Bool {
        return false
    }

    static var implicitValue: ValidArgument {
        return true
    }

    public init(argument: String) throws {
        switch argument {
        case "":
            self = true
        case "true":
            self = true
        case "false":
            self = false
        default:
            throw ArgumentParser.Error.unknown(value: argument)
        }
    }
}

class ArgumentParser {
    enum Error: Swift.Error {
        case argumentNotFound
        case noImplicitValue
        case typeMismatch // TODO: Add Type to this
        case unknown(value: String)
        case invalidValue
        case missingValue
    }

    private let args: [String]

    init(_ args: [String]) {
        self.args = args
    }

    func get<T>(_ option: Option<T>) throws -> T where T: ValidArgument {
        return try self.get(option.name, option.shortName, type: T.self)
    }

    func get<T>(_ name: String, _ shortName: String, type: T.Type) throws -> T where T: ValidArgument {
        // TODO: Error on duplicate names, shortNames, or any combination

        guard let index = self.args.firstIndex(of: name) ?? self.args.firstIndex(of: shortName) else {
            throw Error.argumentNotFound
        }

        // If there is no next argument and this type is a Bool, return true
        // otherwise, throw a missing value error
        guard self.args.indices.contains(index + 1) else {
            if type is Bool.Type, let returnValue = true as? T {
                return returnValue
            } else {
                throw Error.missingValue
            }
        }

        let nextArgument = self.args[index + 1]

        // If the next argument is another option, the current argument has to be a Bool
        // If it's not a Bool, throw an error
        guard !nextArgument.starts(with: "-") else {
            if type is Bool.Type, let returnValue = true as? T {
                return returnValue
            } else {
                throw Error.invalidValue
            }
        }

        let returnValue: T?

        switch type {
        case is Double.Type:
            returnValue = try Double(argument: nextArgument) as? T
        case is Bool.Type:
            returnValue = try Bool(argument: nextArgument) as? T
        case is Int.Type:
            returnValue = try Int(argument: nextArgument) as? T
        case is String.Type:
            returnValue = try String(argument: nextArgument) as? T
        default:
            throw Error.typeMismatch
        }

        guard let value = returnValue else {
            throw Error.invalidValue
        }

        return value

//        guard T.hasExplicitValue else {
//            guard let value = T.implicitValue as? T else {
//                throw Error.typeMismatch
//            }
//
//            return value
//        }
//
//        return
    }
}

extension ArgumentParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .argumentNotFound:
            return "Argument not found."
        case .noImplicitValue:
            return "No implicit value."
        case .typeMismatch:
            return "Type mismatch."
        case .unknown(let value):
            return "Unknown value: \(value)"
        case .invalidValue:
            return "Invalud value."
        case .missingValue:
            return "Missing value."
        }
    }
}

struct Option<T> {
    let name: String
    let shortName: String

    var value: T?

    init(_ name: String, _ shortName: String) {
        self.name = name
        self.shortName = shortName
    }
}

// struct TestOptions {
//    let file: String
//    let version: Int
//
//    static func parse(_ args: [String]) -> TestOptions {
//        let parser = ArgsParser(args)
//        parser.add(Option<String>("file", shortName: "f"))
//        parser.add(Option<Int>("version", shortName: "v"))
//
////        self.file = parser.get("file", shortName: "f")
////
////        let file =
//    }
// }
//
// class ArgsParser {
////    private var options = [OptionProtocol]()
//
//    init(_ args: [String]) {
//
//    }
//
//    func add<T>(_ option: Option<T>) {
//        options.append(option)
//    }
//
//    func get<T>(_ name: String, shortName: String, usage: String? = nil) -> T {
//
//    }
// }
//
// protocol CommandArgument {
//    init(argument: String) throws
//
//    static var completion: ShellCompletion { get }
// }
//
// extension String: CommandArgument {
//
// }
//

// protocol OptionProtocol {
//    associatedtype Value
//
//    var name: String { get }
//    var shortName: String { get }
//    var value: Value? { get set }
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
