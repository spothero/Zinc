// Copyright © 2020 SpotHero, Inc. All rights reserved.

public struct SimulatorDeviceType: Codable {
    public let minRuntimeVersion: Int
    public let bundlePath: String
    public let maxRuntimeVersion: Int
    public let name: String
    public let identifier: String
    public let productFamily: String
}
