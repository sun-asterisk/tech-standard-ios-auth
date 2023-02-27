// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AuthManager",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "BaseAuth",
            targets: ["BaseAuth"]),
        .library(
            name: "CredentialAuth",
            targets: ["CredentialAuth", "CredentialAuthRx"]),
        .library(
            name: "FacebookAuth",
            targets: ["FacebookAuth", "FacebookAuthRx"]),
        .library(
            name: "GoogleAuth",
            targets: ["GoogleAuth", "GoogleAuthRx"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            .upToNextMajor(from: "6.0.0")
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "9.0.0")
        ),
        .package(
            url: "https://github.com/facebook/facebook-ios-sdk.git",
            .upToNextMajor(from: "9.0.0")
        ),
        .package(
            url: "https://github.com/google/GoogleSignIn-iOS.git",
            .upToNextMajor(from: "7.0.0")
        )
    ],
    targets: [
        .target(
            name: "BaseAuth",
            dependencies: [],
            path: "BaseAuth"),
        .target(
            name: "CredentialAuth",
            dependencies: [
                "BaseAuth"
            ],
            path: "CredentialAuth"),
        .target(
            name: "CredentialAuthRx",
            dependencies: [
                "CredentialAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "CredentialAuthRx"),
        .target(
            name: "FacebookAuth",
            dependencies: [
                "BaseAuth",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
            ],
            path: "FacebookAuth"),
        .target(
            name: "FacebookAuthRx",
            dependencies: [
                "FacebookAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "FacebookAuthRx"),
        .target(
            name: "GoogleAuth",
            dependencies: [
                "BaseAuth",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
            ],
            path: "GoogleAuth"),
        .target(
            name: "GoogleAuthRx",
            dependencies: [
                "GoogleAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "GoogleAuthRx"),
    ],
    swiftLanguageVersions: [.v5]
)
