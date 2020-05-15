// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CarbonFramework
@testable import CobaltFramework
import XCTest

final class SimulatorParsingTests: XCTestCase {
    func testParsingSimulatorListJSON() throws {
        guard let json = FileClerk.shared.readRelativeFile("../MockData/simulator_list.json") else {
            XCTFail("JSON file could not be read.")
            return
        }
        
        let simulatorList: SimulatorList
        
        do {
            simulatorList = try SimulatorController.parseSimulatorListJSON(json)
        } catch let decodingError as DecodingError {
            let cleanedMessage = ErrorCleaner.cleanedMessage(for: decodingError)
            XCTFail("Failed to parse Simulator List JSON! Error: \(cleanedMessage)")
            return
        }
        
        XCTAssertEqual(simulatorList.devices.count, 3)
        XCTAssertEqual(simulatorList.devicePairs.count, 2)
        XCTAssertEqual(simulatorList.deviceTypes.count, 53)
        XCTAssertEqual(simulatorList.runtimes.count, 3)
        
        // Test parsing a devices dictionary
        if let (runtime, devices) = simulatorList.devices.min(by: { $0.key < $1.key }) {
            XCTAssertEqual(runtime, "com.apple.CoreSimulator.SimRuntime.iOS-13-4")
            
            // Test parsing a device array
            if let device = devices.first {
                XCTAssertEqual(device.dataPath,
                               "/Users/brian.drelling/Library/Developer/CoreSimulator/Devices/4DEF74B9-E671-4C7A-8E0D-F7344E1CA2E3/data")
                XCTAssertEqual(device.logPath, "/Users/brian.drelling/Library/Logs/CoreSimulator/4DEF74B9-E671-4C7A-8E0D-F7344E1CA2E3")
                XCTAssertEqual(device.udid, "4DEF74B9-E671-4C7A-8E0D-F7344E1CA2E3")
                XCTAssertEqual(device.isAvailable, true)
                XCTAssertEqual(device.deviceTypeIdentifier, "com.apple.CoreSimulator.SimDeviceType.iPhone-8")
                XCTAssertEqual(device.state, "Shutdown")
                XCTAssertEqual(device.name, "iPhone 8")
            }
        }
        
        // Test parsing a device pairs dictionary
        if let (udid, pair) = simulatorList.devicePairs.min(by: { $0.key < $1.key }) {
            XCTAssertEqual(udid, "B345071D-5966-4176-952D-0AED295B5926")
            
            XCTAssertEqual(pair.state, "(active, disconnected)")
            
            XCTAssertEqual(pair.phone.name, "iPhone 11 Pro Max")
            XCTAssertEqual(pair.phone.udid, "111FCBF6-5C4C-4929-9B24-2943A3A874C8")
            XCTAssertEqual(pair.phone.state, "Shutdown")
            
            XCTAssertEqual(pair.watch.name, "Apple Watch Series 5 - 44mm")
            XCTAssertEqual(pair.watch.udid, "D82B6E8F-1B7B-44BC-8330-52EC1BD48D27")
            XCTAssertEqual(pair.watch.state, "Shutdown")
        }
        
        // Test parsing a device type
        if let deviceType = simulatorList.deviceTypes.first {
            // swiftlint:disable:next line_length
            XCTAssertEqual(deviceType.bundlePath, #"/Applications/Xcode 11.4.1.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/DeviceTypes/iPhone 4s.simdevicetype"#)
            XCTAssertEqual(deviceType.identifier, "com.apple.CoreSimulator.SimDeviceType.iPhone-4s")
            XCTAssertEqual(deviceType.minRuntimeVersion, 327680)
            XCTAssertEqual(deviceType.maxRuntimeVersion, 655359)
            XCTAssertEqual(deviceType.name, "iPhone 4s")
            XCTAssertEqual(deviceType.productFamily, "iPhone")
        }
        
        // Test parsing a runtime
        if let runtime = simulatorList.runtimes.first {
            // swiftlint:disable:next line_length
            let bundlePath = #"/Applications/Xcode 11.4.1.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime"#
            let runtimeRootFromBundle = #"/Contents/Resources/RuntimeRoot"#
            
            XCTAssertEqual(runtime.buildVersion, "17E8260")
            XCTAssertEqual(runtime.bundlePath, bundlePath)
            XCTAssertEqual(runtime.identifier, "com.apple.CoreSimulator.SimRuntime.iOS-13-4")
            XCTAssertEqual(runtime.isAvailable, true)
            XCTAssertEqual(runtime.name, "iOS 13.4")
            XCTAssertEqual(runtime.runtimeRoot, "\(bundlePath)\(runtimeRootFromBundle)")
            XCTAssertEqual(runtime.version, "13.4.1")
        }
    }
}
