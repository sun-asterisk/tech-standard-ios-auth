# FacebookAuth - Swift Package

A simple and efficient Swift library for Facebook Login in iOS. The class makes use of the FirebaseAuth and Facebook Login SDK for iOS to provide a user-friendly and customizable sign-in experience, while handling the authentication process in the background.

## Features

- [Login Facebook and Firebase Authentication](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#login-facebook-and-firebase-authentication)
- [Login Facebook](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#login-facebook)
- [Logout Facebook and Firebase Authentication](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#logout-facebook-and-firebase-authentication)
- [Get the Facebook Access Token of the currently logged-in user](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#get-the-facebook-access-token-of-the-currently-logged-in-user)
- [Fetches the user's information from Facebook](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#fetches-the-users-information-from-facebook)
- [Sets the delegate for a given Facebook login button (with Firebase Authentication)](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#sets-the-delegate-for-a-given-facebook-login-button-with-firebase-authentication)
- [Sets the delegate for a given Facebook login button](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#sets-the-delegate-for-a-given-facebook-login-button)
- [Removes the delegate for a given Facebook login button](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth#removes-the-delegate-for-a-given-facebook-login-button)

## Installation

### Requirement

- iOS 13 and above
- Swift 5.7 and above

### Swift Package Manager

To install FacebookAuth using Swift Package Manager, add the following to your `Package.swift` file:

```Swift
dependencies: [
    .package(url: "https://github.com/sun-asterisk/tech-standard-ios-auth", from: "1.0.0")
]
```

Select FacebookAuth package, or FacebookAuthRx package if you use RxSwift.

## Usage

### Prerequisites

In order to use FacebookAuth, you will need to have a Facebook App and Developer Account. You can create one at [developers.facebook.com](https://developers.facebook.com/).

You will also need to [add the Facebook Login SDK to your iOS project](https://developers.facebook.com/docs/facebook-login/ios) and [configure Firebase](https://firebase.google.com/docs/ios/setup).

### Example

Here's an example of how you can use FacebookAuth to log in a user and retrieve their basic profile information:

```swift
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

```swift
if let error = facebookAuth.logout() {
    print("Failed to log out: \(error)")
} else {
    print("Successfully logged out")
}
```

## Documentation

You can see the full documentation [here](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/FacebookAuth).
