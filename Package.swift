// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Zinc",
    products: [
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.10"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.33.1"),
        .package(url: "https://github.com/spothero/CommandHero-iOS", from: "0.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "zinc",
            dependencies: [
                "ZincFramework",
            ],
            path: "Sources/zinc"
        ),
        // This target is not an explicit product since no other packages should reference Zinc in order to get FileHero
        // If this is ever required by another Package, break it out into its own repo
        .target(
            name: "FileHero",
            dependencies: [
                "Lumberjack",
                "ShellRunner",
            ],
            path: "Sources/FileHero"
        ),
        .target(
            name: "ZincFramework",
            dependencies: [
                "CommandHero",
                "FileHero",
                "Lumberjack",
                "Yams", 
            ],
            path: "Sources/ZincFramework"
        ),
        .testTarget(
            name: "ZincTests",
            dependencies: [
                "ZincFramework",
            ],
            path: "Tests/ZincTests"
        ),
    ]
)
