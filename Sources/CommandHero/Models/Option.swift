// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct Option<T> {
    public let defaultValue: T?
    public let description: String?
    public let name: String
    public let shortName: String?

    public init(_ name: String, shortName: String? = nil, defaultValue: T? = nil, description: String? = nil) {
        self.defaultValue = defaultValue
        self.description = description
        self.name = name
        self.shortName = shortName
    }
}
