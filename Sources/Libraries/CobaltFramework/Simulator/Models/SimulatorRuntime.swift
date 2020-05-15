// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorRuntime: Codable {
    let buildVersion: String
    let bundlePath: String
    let identifier: String
    let isAvailable: Bool
    let name: String
    let runtimeRoot: String
    let version: String
    
//    {
//      "bundlePath" : "\/Applications\/Xcode 11.4.1.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS.simruntime",
//      "buildversion" : "17E8260",
//      "runtimeRoot" : "\/Applications\/Xcode 11.4.1.app\/Contents\/Developer\/Platforms\/iPhoneOS.platform\/Library\/Developer\/CoreSimulator\/Profiles\/Runtimes\/iOS.simruntime\/Contents\/Resources\/RuntimeRoot",
//      "identifier" : "com.apple.CoreSimulator.SimRuntime.iOS-13-4",
//      "version" : "13.4.1",
//      "isAvailable" : true,
//      "name" : "iOS 13.4"
//    },
}
