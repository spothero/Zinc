// Copyright © 2020 SpotHero, Inc. All rights reserved.

public struct SimulatorDevicePair: Codable {
    public let watch: SimulatorPairedDevice
    public let phone: SimulatorPairedDevice
    public let state: String
}
