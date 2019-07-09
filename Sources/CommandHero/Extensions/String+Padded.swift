// Copyright © 2019 SpotHero, Inc. All rights reserved.

extension String {
    func padded(by length: Int) -> String {
        return (self as NSString).padding(toLength: length, withPad: " ", startingAt: 0)
    }
}
