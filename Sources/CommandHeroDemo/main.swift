// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import Logging

// Create and run the CommandHero demo command.
do {
    let demoCommand = DemoCommand()
    try demoCommand.run()
} catch {
    let logger = Logger(label: "com.spothero.zinc.CommandHero")
    logger.error("\(error.localizedDescription)")
}
