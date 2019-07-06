// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct Argument<T> {
    public typealias ValueType = T

    public let index: Int

    public init(index: Int) {
        self.index = index
    }
}
