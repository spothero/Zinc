// Copyright © 2019 SpotHero. All rights reserved.

protocol Command {
    // associatedtype Options = CommandOptions

    static var name: String { get }
    static var usageDescription: String { get }

//    var description: String
//    func describe()
//    func run(with options: Options) throws

    init()
    func run(with args: [String]) throws
}

// extension Command {
//    private func options(from args: [String]) -> Options  {
//
//    }
//
//    func run(with args: [String]) {
//
//    }
// }
