// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct Option<T> {
    public let name: String
    public let shortName: String

    // public var value: T

    public init(_ name: String, _ shortName: String) {
        self.name = name
        self.shortName = shortName
    }
}
