// Copyright © 2020 SpotHero, Inc. All rights reserved.

public struct SimulatorDevice: Codable {
    public let dataPath: String
    public let logPath: String
    public let udid: String
    public let isAvailable: Bool
    public let deviceTypeIdentifier: String
    public let state: String // TODO: Convert to enum?
    public let name: String
}
