
// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthManager",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "AuthManager",
            targets: ["AuthManager"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "AuthManager",
            dependencies: [],
            path: "AuthManager/AuthManager"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
