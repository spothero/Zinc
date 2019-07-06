// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import ZincFramework

// We have a single entry point to process arguments
// The Zinc framework will handle all the work!
try? Zinc.shared.process(args: CommandLine.arguments)
