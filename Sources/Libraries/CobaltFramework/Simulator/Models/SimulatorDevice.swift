// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorDevice: Codable {
    let dataPath: String
    let logPath: String
    let udid: String
    let isAvailable: Bool
    let deviceTypeIdentifier: String
    let state: String // TODO: Convert to enum?
    let name: String
}
