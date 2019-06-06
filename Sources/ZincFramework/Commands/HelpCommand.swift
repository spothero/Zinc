// Copyright © 2019 SpotHero. All rights reserved.

class HelpCommand: Command {
    typealias Options = CommandOptions
    
    func run(with options: Options) throws {
        Lumberjack.shared.log("Running help.")
    }
    
    func run(with args: [String]) throws {
        
    }
}
