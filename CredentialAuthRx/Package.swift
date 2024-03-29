// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CredentialAuthRx",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CredentialAuthRx",
            targets: ["CredentialAuthRx"]),
    ],
    dependencies: [
        .package(name: "CredentialAuth", path: "../CredentialAuth"),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.0.0")
        ),
    ],
    targets: [
        .target(
            name: "CredentialAuthRx",
            dependencies: [
                "CredentialAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "CredentialAuthRxTests",
            dependencies: ["CredentialAuthRx"]),
    ]
)
