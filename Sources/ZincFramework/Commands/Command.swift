// Copyright © 2019 SpotHero. All rights reserved.

import Utility

protocol Command {
    associatedtype Options = CommandOptions
//    var description: String
//    func describe()
    func run(with options: Options) throws
    func run(with args: [String], parser: ArgumentParser) throws
}

//extension Command {
//    private func options(from args: [String]) -> Options  {
//
//    }
//
//    func run(with args: [String]) {
//
//    }
//}

