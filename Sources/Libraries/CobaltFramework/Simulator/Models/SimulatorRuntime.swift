// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public struct SimulatorRuntime: Codable {
    public let buildVersion: String
    public let bundlePath: String
    public let identifier: String
    public let isAvailable: Bool
    public let name: String
    public let runtimeRoot: String
    public let version: String
    
    private enum SIMCTLCodingKeys: String, CodingKey {
        case buildVersion = "buildversion"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.bundlePath = try values.decode(String.self, forKey: .bundlePath)
        self.identifier = try values.decode(String.self, forKey: .identifier)
        self.isAvailable = try values.decode(Bool.self, forKey: .isAvailable)
        self.name = try values.decode(String.self, forKey: .name)
        self.runtimeRoot = try values.decode(String.self, forKey: .runtimeRoot)
        self.version = try values.decode(String.self, forKey: .version)
        
        // Unfortunately, simctl doesn't use consistent camelCase for the --json output of the simulator list
        // First, we'll try decode using the proper keys
        if let buildVersion = try values.decodeIfPresent(String.self, forKey: .buildVersion) {
            // If we were successful, we're good to go!
            self.buildVersion = buildVersion
        } else {
            // If we weren't successful, then we need to get a container keyed by the simctl values
            let simctlValues = try decoder.container(keyedBy: SIMCTLCodingKeys.self)
            
            // Decoder and set the build version
            self.buildVersion = try simctlValues.decode(String.self, forKey: .buildVersion)
        }
    }
}
