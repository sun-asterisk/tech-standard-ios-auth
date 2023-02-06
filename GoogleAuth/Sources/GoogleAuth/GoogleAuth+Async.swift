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
    
    /// Sign-in Google and Firebase Auth.
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
    
    /// Sign-in Google.
    /// - Parameter presentingViewController: the presenting view controller
    /// - Returns: sign-in results
    func signIn(presentingViewController: UIViewController? = nil) async -> Result<GIDGoogleUser?, Error> {
        await withCheckedContinuation { continuation in
            signIn(
                presentingViewController: presentingViewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Link auth provider credentials to an existing user account
    /// - Parameters  credential: An object of AuthCredential type.
    /// - Returns: link results
    func link(with credential: AuthCredential) async -> Result<AuthDataResult?, Error> {
        await withCheckedContinuation { continuation in
            link(
                with: credential,
                completion: continuation.resume(returning:)
            )
        }
    }
}
