
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