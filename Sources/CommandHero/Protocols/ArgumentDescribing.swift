// Copyright © 2019 SpotHero, Inc. All rights reserved.

public protocol ArgumentDescribing {
    var name: String { get }
    var description: String? { get }
    var index: Int { get }
}
