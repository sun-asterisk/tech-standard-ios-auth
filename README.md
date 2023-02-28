# iOS AuthManager

This repository includes a collection of packages for handling authentication in iOS applications. It includes implementations for Facebook, Google and standard email/password authentication.

## Installation

#### Requirement

- iOS 13 and above
- Swift 5.7 and above

#### Swift Package Manager

To install AuthManager using Swift Package Manager, add the following to your `Package.swift` file:

```
dependencies: [
    .package(url: "https://github.com/sun-asterisk/tech-standard-ios-auth", from: "1.0.0")
]
```

## Packages

### [CredentialAuth](CredentialAuth/README.md)

CredentialAuth is a Swift package that provides a simple way to handle authentication and token management.

[Full documentation](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth)

### [FacebookAuth](FacebookAuth/README.md)

A simple and efficient Swift library for Facebook Login in iOS. The class makes use of the FirebaseAuth and Facebook Login SDK for iOS to provide a user-friendly and customizable sign-in experience, while handling the authentication process in the background.

[Full documentation](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth)

### [GoogleAuth](GoogleAuth/README.md)

GoogleAuth is a convenient and secure way to sign in to your iOS application using Google credentials. This library is built on top of FirebaseAuth and the Google Sign-In SDK for iOS.

[Full documentation](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth)

## License

AuthManager is available under the Apache-2.0 license. See the LICENSE file for more info.
