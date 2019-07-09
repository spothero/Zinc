// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol ArgumentDescribing {
    var description: String? { get }
    var index: Int { get }
    var name: String { get }
}
