// Copyright © 2019 SpotHero, Inc. All rights reserved.

public class Argument<T>: ArgumentDescribing {
    public typealias ValueType = T.Type

    public var name: String
    public var description: String?
    public var index: Int

    public init(index: Int, name: String, description: String? = nil) {
        self.description = description
        self.index = index
        self.name = name
    }
}
