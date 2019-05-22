// swift-tools-version:5.0

//
//  Package.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "Zinc",
    products: [
        .executable(name: "zinc", targets: ["zinc"]),
        .library(name: "ZincFramework", targets: ["ZincFramework"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: "https://github.com/Carthage/Commandant.git", from: "0.17.0"),
        // .package(url: "https://github.com/JohnSundell/Files.git", from: "3.1.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "2.0.0"),

        //.package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.8"),
        //.package(url: "https://github.com/Realm/SwiftLint", from: "0.32.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "zinc",
            dependencies: [
                "ZincFramework",
            ],
            path: "Sources/zinc"
        ),
        .target(
            name: "ZincFramework",
            dependencies: ["Yams"],
            path: "Sources/ZincFramework"
        ),
        .testTarget(
            name: "ZincTests",
            dependencies: ["ZincFramework"],
            path: "Tests/ZincTests"
        ),
    ]
)
