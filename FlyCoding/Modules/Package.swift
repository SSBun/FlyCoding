// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .macOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Homepage",
            targets: ["Homepage"]),
        .library(
            name: "FlyX",
            targets: ["FlyX"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Homepage",
            dependencies: []),
        .target(
            name: "FlyX",
            path: "Sources/FlyX/Sources"),
        .testTarget(
            name: "FlyXTests",
            dependencies: ["FlyX"],
            path: "Sources/FlyX/Tests")
    ]
)
