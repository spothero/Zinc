// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Logging
import Lumberjack
import ZincFramework

// Use Lumberjack for default log handling
LoggingSystem.bootstrap { _ in
    return LumberjackLogHandler()
}

// We have a single entry point to process arguments
// The Zinc framework will handle all the work!
do {
    try Zinc.shared.run()
} catch {
    let logger = Logger(label: "com.spothero.zinc")
    logger.error("\(error.localizedDescription)")
}
