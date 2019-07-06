// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct CommandContext {
    public let arguments: [String]
    public let options: [String: String]
    public let parser: ArgumentParser
    // public let subcommand: String
}
