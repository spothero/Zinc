// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public class UsageDescriber {
    static let shared = UsageDescriber()

    public func printUsageDescription<T>(for command: T) where T: UsageDescribing {
        Lumberjack.shared.debug(T.usageDescription)
    }

    public func printUsageDescription<T>(for command: T.Type) where T: UsageDescribing {
        Lumberjack.shared.debug(T.usageDescription)
    }
}
