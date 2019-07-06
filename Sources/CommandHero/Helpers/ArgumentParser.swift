// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class ArgumentParser {
    // MARK: - Enums

    enum Error: Swift.Error {
        case argumentNotFound
        case argumentOutOfBounds
        case noImplicitValue
        case optionNotFound(name: String, shortName: String?)
        case typeMismatch // TODO: Add Type to this
        case unknown(value: String)
        case invalidValue
        case missingValue

        static func optionNotFound(name: String) -> Error {
            return .optionNotFound(name: name, shortName: nil)
        }
    }

    // MARK: - Properties

    private let args: [String]

    // MARK: - Methods

    // MARK: Lifecycle

    public init(_ args: [String]) {
        self.args = args
    }

    // MARK: Exists

    public func exists(_ name: String) throws -> Bool {
        return self.args.contains(name)
    }

    public func exists(_ name: String, _ shortName: String) throws -> Bool {
        return try self.exists([name, shortName])
    }

    public func exists(_ names: [String]) throws -> Bool {
        return !Set(self.args).intersection(names).isEmpty
    }

    // MARK: Value for Argument

    public func valueForArgument<T>(atIndex index: Int, type: T.Type = T.self) throws -> T where T: ValidArgument {
        guard self.args.indices.contains(index) else {
            throw Error.argumentOutOfBounds
        }

        let argument = self.args[index]

        guard let value = try self.getValue(for: argument, type: type) else {
            throw Error.invalidValue
        }

        return value
    }

    // MARK: Value for Option

    public func valueForOption<T>(_ option: Option<T>) throws -> T where T: ValidArgument {
        return try self.valueForOption(withName: option.name, shortName: option.shortName, type: T.self)
    }

    public func valueForOption<T>(withName name: String, type: T.Type = T.self) throws -> T where T: ValidArgument {
        guard let index = self.args.firstIndex(of: "--\(name)") else {
            throw Error.optionNotFound(name: name)
        }

        return try self.valueForOption(atIndex: index, type: type)
    }

    public func valueForOption<T>(withName name: String, shortName: String, type: T.Type = T.self) throws -> T where T: ValidArgument {
        guard let index = self.args.firstIndex(of: "--\(name)") ?? self.args.firstIndex(of: "-\(shortName)") else {
            throw Error.optionNotFound(name: name, shortName: shortName)
        }

        return try self.valueForOption(atIndex: index, type: type)
    }

    private func valueForOption<T>(atIndex index: Int, type: T.Type = T.self) throws -> T where T: ValidArgument {
        // If there is no next argument and this type is a Bool, return true
        // otherwise, throw a missing value error
        guard self.args.indices.contains(index + 1) else {
            if type is Bool.Type, let returnValue = true as? T {
                return returnValue
            } else {
                throw Error.missingValue
            }
        }

        let valueArgument = self.args[index + 1]

        // If the next argument is another option, the current argument has to be a Bool
        // If it's not a Bool, throw an error
        guard !valueArgument.starts(with: "-") else {
            if type is Bool.Type, let returnValue = true as? T {
                return returnValue
            } else {
                throw Error.invalidValue
            }
        }

        guard let value = try getValue(for: valueArgument, type: type) else {
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

    // MARK: Utilities

    private func getValue<T>(for argument: String, type: T.Type = T.self) throws -> T? {
        let value: T?

        switch type {
        case is Double.Type:
            value = try Double(argument: argument) as? T
        case is Bool.Type:
            value = try Bool(argument: argument) as? T
        case is Int.Type:
            value = try Int(argument: argument) as? T
        case is String.Type:
            value = try String(argument: argument) as? T
        default:
            throw Error.typeMismatch
        }

        return value
    }
}

// MARK: - Extensions

// MARK: LocalizedError

extension ArgumentParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .argumentNotFound:
            return "Argument not found."
        case .argumentOutOfBounds:
            return "Argument out of bounds."
        case .noImplicitValue:
            return "No implicit value."
        case .optionNotFound(let name, nil):
            return "Option --\(name) not found."
        case .optionNotFound(let name, let .some(shortName)):
            return "Option --\(name)|-\(shortName) not found."
        case .typeMismatch:
            return "Type mismatch."
        case let .unknown(value):
            return "Unknown value: \(value)"
        case .invalidValue:
            return "Invalud value."
        case .missingValue:
            return "Missing value."
        }
    }
}
