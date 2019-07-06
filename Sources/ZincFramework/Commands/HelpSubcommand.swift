// Copyright © 2019 SpotHero, Inc. All rights reserved.

import CommandHero
import Lumberjack

class HelpSubcommand: Subcommand {
    // typealias Options = CommandOptions

    public static var name = "help"
    public static var usageDescription = "This command is the help command."

//    func run(with options: Options) throws {
//        Lumberjack.shared.log("Running help.")
//    }

    public required init() {}

    public func run(withParser parser: ArgumentParser) throws {
        let subcommand: String = try parser.get(0, type: String.self)
        let yikes: String = try parser.get("--yikes", "-y", type: String.self)

        Lumberjack.shared.debug("Subcommand is \(subcommand)")
        Lumberjack.shared.debug("Yikes is \(yikes)")
//        let parser = ArgumentParser(usage: "<options>", overview: "This is how you use the command.")
//        //        let parser = parser
//        let file = parser.add(option: "--file", shortName: "-f", kind: String.self, usage: nil, completion: nil)
//        let version = parser.add(option: "--version", shortName: "-v", kind: Int.self, usage: nil, completion: nil)
//
//        do {
//            let result = try parser.parse(args)
//
//            Lumberjack.shared.log(result)
//        } catch {
//            Lumberjack.shared.report(String(describing: error))
//        }
    }
}