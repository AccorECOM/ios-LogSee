// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LogSee",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16)
    ],
    products: [
        .library(
            name: "LogSee",
            targets: ["LogSee"]),
        .library(
            name: "Logger",
            targets: ["Logger"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LogSee",
            dependencies: ["Logger"]
        ),
        .target(
            name: "Logger"
        ),
        .testTarget(
            name: "LogSeeTests",
            dependencies: ["LogSee"]
        )
    ]
)
