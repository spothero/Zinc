// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorDeviceType: Codable {
    let minRuntimeVersion: Int
    let bundlePath: String
    let maxRuntimeVersion: Int
    let name: String
    let identifier: String
    let productFamily: String
}
