// swift-tools-version:5.1
// Copyright © 2020 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "Elements",
    platforms: [
        .macOS(.v10_10),    // minimum supported version via SPM
        // iOS is unsupported due to the use of command line utilities
        // tvOS is unsupported due to the use of command line utilities
        // watchOS is unsupported due to the use of command line utilities
    ],
    products: [
        .executable(name: "cobalt", targets: ["cobalt"]),
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "CarbonFramework", targets: ["CarbonFramework"]),
        .library(name: "CobaltFramework", targets: ["CobaltFramework"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
        // Source stability for ArgumentParser is only guaranteed up to the next minor version
        .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.0.5")),
    ],
    targets: [
        // Executable Product Targets
        .target(
            name: "cobalt",
            dependencies: [
                .target(name: "CobaltFramework"),
            ],
            path: "Sources/Executables/cobalt"
        ),
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
            name: "CobaltFramework",
            dependencies: [
                .target(name: "CarbonFramework"),
                "ArgumentParser",
            ],
            path: "Sources/Libraries/CobaltFramework"
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
            name: "CobaltTests",
            dependencies: [
                .target(name: "CobaltFramework"),
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
