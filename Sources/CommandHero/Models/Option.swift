// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol OptionDescribing {
    var defaultValueDescription: String { get }
    var description: String? { get }
    var name: String { get }
    var shortName: String? { get }
    var usageDisplayName: String { get }
}

public extension OptionDescribing {
    var usageDisplayName: String {
        if let shortName = self.shortName {
            return "-\(shortName), --\(self.name)"
        } else {
            return "--\(self.name)"
        }
    }
}

public class Option<T>: OptionDescribing {
    public var defaultValue: T?
    public var description: String?
    public var name: String
    public var shortName: String?

    public var defaultValueDescription: String {
        return String(describing: self.defaultValue)
    }

    public init(_ name: String, shortName: String? = nil, defaultValue: T? = nil, description: String? = nil) {
        self.defaultValue = defaultValue
        self.description = description
        self.name = name
        self.shortName = shortName
    }
}
