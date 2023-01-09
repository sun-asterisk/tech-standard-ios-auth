// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleAuthRx",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GoogleAuthRx",
            targets: ["GoogleAuthRx"]),
    ],
    dependencies: [
        .package(name: "GoogleAuth", path: "../GoogleAuth"),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.0.0")
        ),
    ],
    targets: [
        .target(
            name: "GoogleAuthRx",
            dependencies: [
                "GoogleAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "GoogleAuthRxTests",
            dependencies: ["GoogleAuthRx"]),
    ]
)
