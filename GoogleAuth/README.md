# GoogleAuth

GoogleAuth is a convenient and secure way to sign in to your iOS application using Google credentials. This library is built on top of FirebaseAuth and the Google Sign-In SDK for iOS.

## Features

- [Restores the previous sign-in session](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth#restores-the-previous-sign-in-session)
- [Signs the user in with Google and Firebase Auth](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth#signs-the-user-in-with-google-and-firebase-auth)
- [Signs the user in with Google](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth#signs-the-user-in-with-google)
- [Sign out Google and Firebase Auth](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth#sign-out-google-and-firebase-auth)

## Installation

### Requirement

- iOS 13 and above
- Swift 5.7 and above

### Swift Package Manager

To install GoogleAuth using Swift Package Manager, add the following to your `Package.swift` file:

```Swift
dependencies: [
    .package(url: "https://github.com/sun-asterisk/tech-standard-ios-auth", from: "1.0.0")
]
```

Select GoogleAuth package, or GoogleAuthRx package if you use RxSwift.

## Usage

### Prerequisites

- [Configure your Firebase project](https://firebase.google.com/docs/ios/setup)
- [Get started with Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating)

### Example

```Swift
import GoogleAuth

// Initiate the sign-in process
GoogleAuth.shared.signIn(presentingViewController: self) { result in
    switch result {
    case .success(let user):
        // The user is signed in successfully. The user object contains information about the signed-in user.
    case .failure(let error):
        // An error occurred during the sign-in process.
    }
}

// Restores the previous sign-in session
GoogleAuth.shared.restorePreviousSignIn { result in
    switch result {
    case .success(let user):
        // User has already signed in before
        // You can use the user object to get their details
        print("Welcome back, \(user.profile?.name ?? "User")!")
        // Perform any necessary actions with the signed-in user
    case .failure(let error):
        // User has not signed in before
        print("Please sign in.")
    }
}

// Sign out
if let error = GoogleAuth.shared.signOut() {
    print("Failed to sign out: \(error)")
} else {
    print("Successfully signed out")
}
```

## Documentation

You can see the full documentation [here](https://github.com/sun-asterisk/tech-standard-ios-auth/wiki/GoogleAuth).
