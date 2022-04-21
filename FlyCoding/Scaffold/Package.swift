// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Scaffold",
    platforms: [
        .iOS(.v13),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "Scaffold",
            targets: ["Scaffold"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Scaffold",
            dependencies: []),
    ]
)
