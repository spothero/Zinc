// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import Lumberjack

// Create and run the CommandHero demo command.
do {
    let demoCommand = DemoCommand()
    try demoCommand.run()
} catch {
    Lumberjack.shared.report(error)
}
