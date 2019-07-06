// Copyright © 2019 SpotHero, Inc. All rights reserved.

public struct CommandContext {
    let command: String?
    let subcommand: String?
    let arguments: [String]?
    let options: [String: String]?
}
