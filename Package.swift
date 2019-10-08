// swift-tools-version:5.1

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
    ],
    dependencies: [
        .package(url: "https://github.com/spothero/CommandHero-iOS", from: "0.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "zinc",
            dependencies: [
                .target(name: "ZincFramework"),
            ]
        ),
        // FileHero is not an explicit product since no other packages should reference Zinc in order to get FileHero
        // If this is ever required by another Package, break it out into its own repo
        .target(
            name: "FileHero",
            dependencies: [
                "Lumberjack",
                "ShellRunner",
            ]
        ),
        .target(
            name: "ZincFramework",
            dependencies: [
                "CommandHero",
                "FileHero",
                "Lumberjack",
                "Yams", 
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
