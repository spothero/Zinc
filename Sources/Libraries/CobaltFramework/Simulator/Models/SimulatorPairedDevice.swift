// Copyright © 2020 SpotHero, Inc. All rights reserved.

public struct SimulatorPairedDevice: Codable {
    public let name: String
    public let udid: String
    public let state: String // TODO: Enum?
}
