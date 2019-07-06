// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import Lumberjack
import ZincFramework

// We have a single entry point to process arguments
// The Zinc framework will handle all the work!
do {
    try Zinc.shared.run(withArgs: CommandLine.arguments)
} catch {
    Lumberjack.shared.report(error)
}
