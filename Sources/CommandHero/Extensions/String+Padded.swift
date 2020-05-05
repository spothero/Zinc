// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension String {
    func padded(by length: Int) -> String {
        return (self as NSString).padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
