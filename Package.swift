// swift-tools-version:5.1
// Copyright © 2020 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "Zinc",
    platforms: [
        .iOS(.v8),          // minimum supported version via SPM
        .macOS(.v10_10),    // minimum supported version via SPM
        .tvOS(.v9),         // minimum supported version via SPM
        .watchOS(.v2),      // minimum supported version via SPM
    ],
    products: [
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"]),
        .library(name: "CommandHero", targets: ["CommandHero"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
    ],
    targets: [
        // Executable Product Targets
        .target(
            name: "zinc",
            dependencies: [
                .target(name: "ZincFramework"),
            ]
        ),
        // Library Product Targets
        .target(
            name: "CommandHero",
            dependencies: [
                .target(name: "Lumberjack"),
                .target(name: "ShellRunner"),
            ]
        ),
        .target(
            name: "ZincFramework",
            dependencies: [
                .target(name: "CommandHero"),
                .target(name: "FileHero"),
                .target(name: "Lumberjack"),
                "Yams",
            ]
        ),
        // Internal Targets
        .target(
            name: "CommandHeroDemo",
            dependencies: [
                .target(name: "CommandHero"),
                .target(name: "Lumberjack"),
            ]
        ),
        .target(
            name: "FileHero",
            dependencies: [
                .target(name: "Lumberjack"),
                .target(name: "ShellRunner"),
            ]
        ),
        .target(
            name: "ShellRunner",
            dependencies: [
                .target(name: "Lumberjack"),
            ]
        ),
        .target(
            name: "Lumberjack",
            dependencies: []
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
