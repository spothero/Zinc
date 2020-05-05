// Copyright © 2020 SpotHero, Inc. All rights reserved.

public protocol SubcommandUsageDescribing: UsageDescribing {
    static var arguments: [ArgumentDescribing] { get }
    static var options: [OptionDescribing] { get }
}
