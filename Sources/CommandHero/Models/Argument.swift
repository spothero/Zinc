// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct Argument<T> {
    public typealias ValueType = T.Type

    public let description: String?
    public let index: Int

    public init(index: Int, description: String? = nil) {
        self.description = description
        self.index = index
    }
}
