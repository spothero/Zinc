// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorDeviceType: Codable {
    let minRuntimeVersion: Int
    let bundlePath: String
    let maxRuntimeVersion: Int
    let name: String
    let identifier: String
    let productFamily: String
    
//    {
//      "minRuntimeVersion" : 327680,
//      "bundlePath" : "\/Applications\/Xcode 11.4.1.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/DeviceTypes\/iPhone 4s.simdevicetype",
//      "maxRuntimeVersion" : 655359,
//      "name" : "iPhone 4s",
//      "identifier" : "com.apple.CoreSimulator.SimDeviceType.iPhone-4s",
//      "productFamily" : "iPhone"
//    },
}
