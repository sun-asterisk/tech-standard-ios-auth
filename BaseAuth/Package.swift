// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BaseAuth",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BaseAuth",
            targets: ["BaseAuth"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "BaseAuth",
            dependencies: []),
        .testTarget(
            name: "BaseAuthTests",
            dependencies: ["BaseAuth"]),
    ]
)
