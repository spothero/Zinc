// Copyright © 2019 SpotHero. All rights reserved.

import Utility

class HelpCommand: Command {
    // typealias Options = CommandOptions

    static var name = "help"
    static var usageDescription = "This command is the help command."

//    func run(with options: Options) throws {
//        Lumberjack.shared.log("Running help.")
//    }

    required init() {}

    func run(with args: [String]) throws {
//        let parser = ArgumentParser(usage: "<options>", overview: "Thsi is how you use the command.")
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
