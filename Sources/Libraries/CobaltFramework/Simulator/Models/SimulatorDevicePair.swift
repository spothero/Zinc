// Copyright © 2020 SpotHero, Inc. All rights reserved.

struct SimulatorDevicePair: Codable {
    let watch: SimulatorPairedDevice
    let phone: SimulatorPairedDevice
    let state: String // TODO: Enum?
    
//    "B345071D-5966-4176-952D-0AED295B5926" : {
//      "watch" : {
//        "name" : "Apple Watch Series 5 - 44mm",
//        "udid" : "D82B6E8F-1B7B-44BC-8330-52EC1BD48D27",
//        "state" : "Shutdown"
//      },
//      "phone" : {
//        "name" : "iPhone 11 Pro Max",
//        "udid" : "111FCBF6-5C4C-4929-9B24-2943A3A874C8",
//        "state" : "Shutdown"
//      },
//      "state" : "(active, disconnected)"
//    },
}
