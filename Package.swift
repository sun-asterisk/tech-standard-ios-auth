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
            targets: ["CredentialAuth"]),
        .library(
            name: "CredentialAuthRx",
            targets: ["CredentialAuthRx"]),
        .library(
            name: "FacebookAuth",
            targets: ["FacebookAuth"]),
        .library(
            name: "FacebookAuthRx",
            targets: ["FacebookAuthRx"]),
        .library(
            name: "GoogleAuth",
            targets: ["GoogleAuth"]),
        .library(
            name: "GoogleAuthRx",
            targets: ["GoogleAuthRx"]),
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
            path: "BaseAuth",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "CredentialAuth",
            dependencies: [
                "BaseAuth"
            ],
            path: "CredentialAuth",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "CredentialAuthRx",
            dependencies: [
                "CredentialAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "CredentialAuthRx",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "FacebookAuth",
            dependencies: [
                "BaseAuth",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk"),
            ],
            path: "FacebookAuth",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "FacebookAuthRx",
            dependencies: [
                "FacebookAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "FacebookAuthRx",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "GoogleAuth",
            dependencies: [
                "BaseAuth",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "GoogleSignInSwift", package: "GoogleSignIn-iOS"),
            ],
            path: "GoogleAuth",
            exclude: ["Package.swift"]
        ),
        .target(
            name: "GoogleAuthRx",
            dependencies: [
                "GoogleAuth",
                .product(name: "RxSwift", package: "RxSwift"),
            ],
            path: "GoogleAuthRx",
            exclude: ["Package.swift"]
        ),
    ],
    swiftLanguageVersions: [.v5]
)
