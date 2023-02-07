# FacebookAuth - Swift Package

A simple and efficient Swift library for Facebook Login in iOS. The class makes use of the FirebaseAuth and Facebook Login SDK for iOS to provide a user-friendly and customizable sign-in experience, while handling the authentication process in the background.

## Getting Started

These instructions will help you get started with integrating FacebookAuth into your iOS project.

### Prerequisites

In order to use FacebookAuth, you will need to have a Facebook App and Developer Account. You can create one at [developers.facebook.com](https://developers.facebook.com/).

You will also need to add the Facebook Login SDK to your iOS project. You can do this by following the instructions at [facebook.com/docs/facebook-login/ios](https://developers.facebook.com/docs/facebook-login/ios).

### Installation

You can install FacebookAuth using Swift Package Manager by adding the following dependency to your `Package.swift` file:

```Swift
.package(url: "https://github.com/{username}/FacebookAuth.git", from: "1.0.0")
```

## Usage

Here's an example of how you can use FacebookAuth to log in a user and retrieve their basic profile information:

```Swift
import FacebookAuth

let facebookAuth = FacebookAuth.shared

// Log in the user
facebookAuth.login(permissions: [.publicProfile], fields: "id, name, email", viewController: self) { result in
    switch result {
    case .success(let authDataResult, let userInfo):
        print("Successfully logged in as \(userInfo["name"])")
    case .failure(let error):
        print("Failed to log in: \(error)")
    }
}

// Get the user's profile information
facebookAuth.getUserInfo(fields: "id, name, email") { result in
    switch result {
    case .success(let userInfo):
        print("User info: \(userInfo)")
    case .failure(let error):
        print("Failed to retrieve user info: \(error)")
    }
}

```

You can also use the `logout()` method to log out the current user:

```
if let error = facebookAuth.logout() {
    print("Failed to log out: \(error)")
} else {
    print("Successfully logged out")
}
```
