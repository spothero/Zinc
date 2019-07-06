// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct Option<T> {
    let name: String
    let shortName: String

    var value: T?

    init(_ name: String, _ shortName: String) {
        self.name = name
        self.shortName = shortName
    }
}
