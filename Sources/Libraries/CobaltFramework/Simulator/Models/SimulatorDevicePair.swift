// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorDevicePair: Codable {
    let watch: SimulatorPairedDevice
    let phone: SimulatorPairedDevice
    let state: String // TODO: Enum?
}
