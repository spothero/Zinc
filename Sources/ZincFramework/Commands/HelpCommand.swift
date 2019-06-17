// Copyright © 2019 SpotHero, Inc. All rights reserved.

class HelpCommand: Command {
    func run() throws {
        Lumberjack.shared.log("Running help.")
    }
}
