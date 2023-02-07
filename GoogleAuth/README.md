# GoogleAuth

GoogleAuth is a convenient and secure way to sign in to your iOS application using Google credentials. This library is built on top of [FirebaseAuth](https://firebase.google.com/docs/auth) and the [Google Sign-In SDK for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating).

## Installation

You can install GoogleAuth using Swift Package Manager by adding the following dependency to your `Package.swift` file:

```Swift
.package(url: "https://github.com/{username}/GoogleAuth.git", from: "1.0.0")
```

## Usage

To use GoogleAuth in your application, you need to follow these steps:

* [Configure your Firebase project](https://firebase.google.com/docs/ios/setup) and add the Google Sign-In SDK for iOS to your project.

* Import the GoogleAuth module:

```Swift
import GoogleAuth
```

* Call the `signIn` method of the `GoogleAuth.shared` instance to initiate the sign-in process:

```Swift
GoogleAuth.shared.signIn(presentingViewController: self) { result in
    switch result {
    case .success(let user):
        // The user is signed in successfully. The user object contains information about the signed-in user.
    case .failure(let error):
        // An error occurred during the sign-in process.
    }
}
```

### Available Methods

* `restorePreviousSignIn`: Restore the previous sign-in session if one exists.
* `signIn`: Initiate the sign-in process. You can specify a presenting view controller if you want the sign-in UI to be presented modally.
* `signOut`: Sign out the current user.
* `link`: Link the current user with another authentication provider (e.g., Google).
