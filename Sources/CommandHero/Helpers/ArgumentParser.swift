// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public class ArgumentParser {
    // MARK: - Enums

    enum Error: Swift.Error {
        case argumentNotFound(index: Int)
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

    public func value<T>(for argument: Argument<T>) throws -> T where T: ValidArgument {
        return try self.value(forArgumentAtIndex: argument.index, type: T.self)
    }

    public func valueIfPresent<T>(for argument: Argument<T>) throws -> T? where T: ValidArgument {
        do {
            return try self.value(for: argument)
        } catch {
            return nil
        }
    }

    public func value<T>(forArgumentAtIndex index: Int, type: T.Type = T.self) throws -> T where T: ValidArgument {
        guard self.args.indices.contains(index) else {
            throw Error.argumentNotFound(index: index)
        }

        let argument = self.args[index]

        guard let value = try self.value(forArgument: argument, type: type) else {
            throw Error.invalidValue
        }

        return value
    }

    // FIXME: Temporarily broken until solution is in place for capturing or not capturing arguments that have hyphen prefixes
    public func valueIfPresent<T>(forArgumentAtIndex index: Int, type: T.Type = T.self) throws -> T? where T: ValidArgument {
        do {
            return try self.value(forArgumentAtIndex: index, type: type)
        } catch {
            return nil
        }
    }

    private func value<T>(forArgument argument: String, type: T.Type = T.self) throws -> T? {
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

    // MARK: Value for Option

    public func value<T>(for option: Option<T>) throws -> T where T: ValidArgument {
        return try self.value(forOption: option.name, shortName: option.shortName, defaultValue: option.defaultValue, type: T.self)
    }

    public func valueIfPresent<T>(for option: Option<T>) throws -> T? where T: ValidArgument {
        do {
            return try self.value(for: option)
        } catch {
            return nil
        }
    }

    public func value<T>(forOption name: String, shortName: String? = nil, defaultValue: T? = nil, type: T.Type = T.self) throws -> T where T: ValidArgument {
        if let index = self.args.firstIndex(of: "--\(name)") {
            return try self.valueForOption(atIndex: index, type: type)
        } else if let shortName = shortName, let index = self.args.firstIndex(of: "-\(shortName)") {
            return try self.valueForOption(atIndex: index, type: type)
        } else if let defaultValue = defaultValue {
            return defaultValue
        } else {
            throw Error.optionNotFound(name: name, shortName: shortName)
        }
    }

    public func valueIfPresent<T>(forOption name: String, shortName: String, type: T.Type = T.self) throws -> T? where T: ValidArgument {
        do {
            return try self.value(forOption: name, shortName: shortName, type: type)
        } catch {
            return nil
        }
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

        guard let value = try self.value(forArgument: valueArgument, type: type) else {
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

// MARK: - Extensions

// MARK: LocalizedError

extension ArgumentParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .argumentNotFound(index):
            return "Argument not found at index \(index)."
        case .argumentOutOfBounds:
            return "Argument out of bounds."
        case .noImplicitValue:
            return "No implicit value."
        case .optionNotFound(let name, nil):
            return "Option --\(name) not found."
        case let .optionNotFound(name, .some(shortName)):
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
