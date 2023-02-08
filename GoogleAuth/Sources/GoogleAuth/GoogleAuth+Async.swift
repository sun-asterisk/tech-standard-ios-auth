import Foundation
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Restores the previous sign-in session, if it exists.
    /// - Returns: Result containing the user info if successful, or an error if the sign-in failed.
    func restorePreviousSignIn() async -> Result<GIDGoogleUser, Error> {
        await withCheckedContinuation { continuation in
            restorePreviousSignIn(completion: continuation.resume(returning:))
        }
    }
    
    /// Signs the user in with Google and Firebase Auth, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: A `Result` value, which can either be a tuple of `(AuthDataResult?, GIDGoogleUser?)` on success or an `Error` on failure.
    func signIn(presentingViewController: UIViewController? = nil) async -> Result<(AuthDataResult?, GIDGoogleUser?), Error> {
        await withCheckedContinuation { continuation in
            signIn(
                presentingViewController: presentingViewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Signs the user in with Google, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: A `Result` value, which can either be a `GIDGoogleUser` on success or an `Error` on failure.
    func signIn(presentingViewController: UIViewController? = nil) async -> Result<GIDGoogleUser?, Error> {
        await withCheckedContinuation { continuation in
            signIn(
                presentingViewController: presentingViewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Link auth provider credentials to an existing user account.
    /// - Parameters  credential: An object of AuthCredential type.
    /// - Returns: A `Result` value, which can either be an `AuthDataResult` on success or an `Error` on failure.
    func link(with credential: AuthCredential) async -> Result<AuthDataResult?, Error> {
        await withCheckedContinuation { continuation in
            link(
                with: credential,
                completion: continuation.resume(returning:)
            )
        }
    }
}
