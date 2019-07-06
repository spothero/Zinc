// Copyright © 2019 SpotHero, Inc. All rights reserved.

// import Lumberjack

// class HelpSubcommand: Subcommand {
//     public static var name = "help"
//     public static var usageDescription = "This command is the help command."

//     public required init() {}

//     public func run(withParser parser: ArgumentParser) throws {
//         let subcommand: String = try parser.get(0, type: String.self)
//         let yikes: String = try parser.get("--yikes", "-y", type: String.self)

//         Lumberjack.shared.debug("Subcommand is \(subcommand)")
//         Lumberjack.shared.debug("Yikes is \(yikes)")
//     }
// }
