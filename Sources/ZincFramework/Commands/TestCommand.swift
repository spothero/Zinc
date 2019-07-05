// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

class TestCommand: Command {
//     typealias Options = TestOptions

    static var name = "test"
    static var usageDescription = "This command is the test command."

//    func run(with options: Options) throws {
    ////        self.lint()
//    }

    required init() {}

    func run(with args: [String]) throws {
        let parser = ArgumentParser(args)

        let file: String = try parser.get("--file", "-f", type: String.self)
        let version: Double = try parser.get("--version", "-v", type: Double.self)
        let build: Int = try parser.get("--build", "-v", type: Int.self)
        let isDope: Bool = try parser.get("--dope", "-d", type: Bool.self)
//        let path: String? = try parser.get("--path", "-p", type: String.self)

        Lumberjack.shared.log([file, version, build, isDope])
//
        ////        let parser = parser
//        let file = parser.add(option: "--file", shortName: "-f", kind: String.self, usage: nil, completion: nil)
//        let version = parser.add(option: "--version", shortName: "-v", kind: Int.self, usage: nil, completion: nil)
//
//        do {
//            let result = try parser.get(args)
//
//            Lumberjack.shared.log(result)
//        } catch {
//            Lumberjack.shared.report(String(describing: error))
//        }
    }
}
