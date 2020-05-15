// Copyright © 2020 SpotHero, Inc. All rights reserved.

public struct SimulatorList: Codable {
    public let devices: [String: [SimulatorDevice]]
    public let devicePairs: [String: SimulatorDevicePair]
    public let deviceTypes: [SimulatorDeviceType]
    public let runtimes: [SimulatorRuntime]
    
    private enum SIMCTLCodingKeys: String, CodingKey {
        case devicePairs = "pairs"
        case deviceTypes = "devicetypes"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.devices = try values.decode([String: [SimulatorDevice]].self, forKey: .devices)
        self.runtimes = try values.decode([SimulatorRuntime].self, forKey: .runtimes)
        
        // Unfortunately, simctl doesn't use consistent camelCase for the --json output of the simulator list
        // First, we'll try decode using the proper keys
        let devicePairs = try values.decodeIfPresent([String: SimulatorDevicePair].self, forKey: .devicePairs)
        let deviceTypes = try values.decodeIfPresent([SimulatorDeviceType].self, forKey: .deviceTypes)
        
        // If we were successful, we're good to go!
        if let devicePairs = devicePairs, let deviceTypes = deviceTypes {
            self.devicePairs = devicePairs
            self.deviceTypes = deviceTypes
        } else {
            // If we weren't successful, then we need to get a container keyed by the simctl values
            let simctlValues = try decoder.container(keyedBy: SIMCTLCodingKeys.self)
            
            // For each type, try to use the value we got (if any), otherwise decode from the simctl decoded container
            self.devicePairs = try devicePairs ?? simctlValues.decode([String: SimulatorDevicePair].self, forKey: .devicePairs)
            self.deviceTypes = try deviceTypes ?? simctlValues.decode([SimulatorDeviceType].self, forKey: .deviceTypes)
        }
    }
}
