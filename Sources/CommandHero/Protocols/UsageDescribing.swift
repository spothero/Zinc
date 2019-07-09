// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation

public protocol UsageDescribing {
    static var name: String { get }
    static var usageDescription: String { get }
    static var formattedUsageDescription: String { get }

    static func printUsageDescription()
}

public extension UsageDescribing {
    static var formattedUsageDescription: String {
        return "\(Self.name): \(Self.usageDescription)"
    }

    static func printUsageDescription() {
        UsageDescriber.shared.printUsageDescription(for: self)
    }
}
