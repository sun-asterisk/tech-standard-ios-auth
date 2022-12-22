// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CredentialAuth",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CredentialAuth",
            targets: ["CredentialAuth"]),
    ],
    dependencies: [
        .package(name: "BaseAuth", path: "../BaseAuth")
    ],
    targets: [
        .target(
            name: "CredentialAuth",
            dependencies: [
                "BaseAuth"
            ]),
        .testTarget(
            name: "CredentialAuthTests",
            dependencies: ["CredentialAuth"]),
    ]
)
