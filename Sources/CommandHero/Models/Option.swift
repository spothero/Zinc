// Copyright © 2019 SpotHero, Inc. All rights reserved.

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
