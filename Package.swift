// swift-tools-version:5.1
// Copyright © 2020 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "Zinc",
    platforms: [
        .macOS(.v10_13),    // supports updated Process API
        // iOS is unsupported due to the use of command line utilities
        // tvOS is unsupported due to the use of command line utilities
        // watchOS is unsupported due to the use of command line utilities
    ],
    products: [
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", .upToNextMajor(from: "4.0.2")),
        // Source stability for ArgumentParser is only guaranteed up to the next minor version
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.3.1")),
    ],
    targets: [
        // Executable Product Targets
        .target(
            name: "zinc",
            dependencies: [
                .target(name: "ZincFramework"),
            ],
            path: "Sources/Executables/zinc"
        ),
        // Library Product Targets
        .target(
            name: "CarbonFramework",
            dependencies: [],
            path: "Sources/Libraries/CarbonFramework"
        ),
        .target(
            name: "ZincFramework",
            dependencies: [
                .target(name: "CarbonFramework"),
                "ArgumentParser",
                "Yams",
            ],
            path: "Sources/Libraries/ZincFramework"
        ),
        // Test Targets
        .testTarget(
            name: "CarbonTests",
            dependencies: [
                .target(name: "CarbonFramework"),
            ]
        ),
        .testTarget(
            name: "ZincTests",
            dependencies: [
                .target(name: "ZincFramework"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
