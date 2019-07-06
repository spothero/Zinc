// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Lumberjack

public class UsageDescriber {
    // MARK: - Shared Instance

    static let shared = UsageDescriber()

    // MARK: - Enums

    public enum PrintMode {
        case snippet
        case manual
    }

    // MARK: - Methods

    public func printUsageDescription<T>(for command: T) where T: UsageDescribing {
        self.printUsageDescription(T.usageDescription, mode: .snippet)
    }

    public func printUsageDescription<T>(for command: T.Type) where T: UsageDescribing {
        self.printUsageDescription(T.usageDescription, mode: .snippet)
    }

    private func printUsageDescription(_ usageDescription: String, mode: PrintMode) {
        switch mode {
        case .snippet:
            self.printSnippetUsageDescription(usageDescription)
        case .manual:
            self.printManualUsageDescription(usageDescription)
        }
    }

    private func printSnippetUsageDescription(_ usageDescription: String) {
        let text =
            """
            usage: name [--file] [--wow]
            """

        Lumberjack.shared.log(text)
    }

    private func printManualUsageDescription(_ usageDescription: String) {
        let text =
            """
            NAME
                    name

            SYNOPSIS
                    name [-f | --file]

            DESCRIPTION
                    \(usageDescription)

            OPTIONS
                    -f, --file
                        File gets passed into the command.
            """

        Lumberjack.shared.log(text)
    }
}
