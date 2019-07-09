// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Zinc",
    products: [
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "FileHero", targets: ["FileHero"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.8"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.32.0"),
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
