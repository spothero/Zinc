
import Foundation

class ArgumentParser {
    enum Error: Swift.Error {
        case argumentNotFound
        case argumentOutOfBounds
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

    func get<T>(_ index: Int, type: T.Type) throws -> T where T: ValidArgument {
        guard self.args.indices.contains(index) else {
            throw Error.argumentOutOfBounds
        }

        let argument = self.args[index]

        guard let value = try self.getValue(for: argument, type: type) else {
            throw Error.invalidValue
        }

        return value
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

    private func getValue<T>(for argument: String, type: T.Type) throws -> T? {
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

extension ArgumentParser.Error: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .argumentNotFound:
            return "Argument not found."
        case .argumentOutOfBounds:
            return "Argument out of bounds."
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