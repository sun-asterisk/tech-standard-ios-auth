// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GoogleAuth",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "GoogleAuth",
            targets: ["GoogleAuth"]),
    ],
    dependencies: [
        .package(name: "BaseAuth", path: "../BaseAuth"),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "9.0.0")
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS.git",
            .upToNextMajor(from: "7.0.0")
        )
    ],
    targets: [
        .target(
            name: "GoogleAuth",
            dependencies: [
                "BaseAuth",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
            ]),
        .testTarget(
            name: "GoogleAuthTests",
            dependencies: ["GoogleAuth"]),
    ]
)
