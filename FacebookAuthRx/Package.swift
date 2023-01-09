// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FacebookAuthRx",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "FacebookAuthRx",
            targets: ["FacebookAuthRx"]),
    ],
    dependencies: [
        .package(name: "FacebookAuth", path: "../FacebookAuth"),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.0.0")
        ),
    ],
    targets: [
        .target(
            name: "FacebookAuthRx",
            dependencies: [
                "FacebookAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ]),
        .testTarget(
            name: "FacebookAuthRxTests",
            dependencies: ["FacebookAuthRx"]),
    ]
)
