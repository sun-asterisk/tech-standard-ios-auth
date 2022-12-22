import Foundation
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: signed-in user
    func restorePreviousSignIn() async -> Result<GIDGoogleUser, Error> {
        await withCheckedContinuation { continuation in
            restorePreviousSignIn(completion: continuation.resume(returning:))
        }
    }
    
    /// Starts an interactive sign-in flow on iOS.
    /// - Parameter presentingViewController: the presenting view controller
    /// - Returns: sign-in results
    func signIn(presentingViewController: UIViewController? = nil) async -> Result<(AuthDataResult?, GIDGoogleUser?), Error> {
        await withCheckedContinuation { continuation in
            signIn(
                presentingViewController: presentingViewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Sign out Google and Firebase Auth.
    /// - Returns: sign-out results
    func signOut() async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            signOut(completion: continuation.resume(returning:))
        }
    }
}
