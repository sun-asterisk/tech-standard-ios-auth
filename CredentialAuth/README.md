# CredentialAuth - Swift Package

CredentialAuth is a Swift package that provides a simple way to handle authentication and token management.

## Features

- [Login using provided credentials](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth#login-using-provided-credentials)
- [Logout the user](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth#logout-the-user)
- [Get the current authentication token (refresh token if it expires)](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth#get-the-current-authentication-token-refresh-token-if-it-expires)
- [Get the current authentication token](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth#get-the-current-authentication-token)
- [Get the current authenticated user](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth#get-the-current-authenticated-user)

## Installation

### Requirement

- iOS 13 and above
- Swift 5.7 and above

### Swift Package Manager

To install CredentialAuth using Swift Package Manager, add the following to your `Package.swift` file:

```Swift
dependencies: [
    .package(url: "https://github.com/<username>/CredentialAuth.git", from: "1.0.0")
]
```

In case of using RxSwift:

```Swift
dependencies: [
    .package(url: "https://github.com/<username>/CredentialAuthRx.git", from: "1.0.0")
]
```

## Usage

### Prerequisites

Set a delegate for `CredentialAuth`:

```Swift
import CredentialAuth

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Credential
        CredentialAuth.shared.delegate = self
        
        return true
    }
}

extension AppDelegate: CredentialAuthDelegate {
    func login(credential: [String : Any],
               success: @escaping (Token, User?) -> Void,
               failure: @escaping (Error) -> Void) {

    }
    
    func logout(credential: [String : Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?) {

    }
    
    func refreshToken(refreshToken: String, success: @escaping (Token) -> Void, failure: @escaping (Error) -> Void) {

    }
}
```

### Example

Here's an example of how to use the CredentialAuth package:

```Swift
import CredentialAuth

// initialize CredentialAuth
let auth = CredentialAuth.shared

// Login the user
auth.login(credential: ["username": "user", "password": "pass"]) { (result) in
    switch result {
    case .success:
        print("Login successful")
    case .failure(let error):
        print("Login failed with error: \(error)")
    }
}

// Get the token
if let token = auth.getToken() {
    print("Token: \(token)")
}

// Get the authenticated user
if let user = auth.getUser() {
    print("User: \(user)")
}

// Logout the user
auth.logout() { (result) in
    switch result {
    case .success:
        print("Logout successful")
    case .failure(let error):
        print("Logout failed with error: \(error)")
    }
}
```

## Documentation

You can see the full documentation [here](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/CredentialAuth).
