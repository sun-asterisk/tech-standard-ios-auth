import Combine
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Restores the previous sign-in session, if it exists.
    /// - Returns: A publisher emitting the user info if successful, or an error if the sign-in failed.
    func restorePreviousSignIn() -> AnyPublisher<GIDGoogleUser, Error> {
        Future { [weak self] promise in
            self?.restorePreviousSignIn(completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs the user in with Google and Firebase Auth, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: A publisher emitting the `AuthDataResult` and user info if successful, or an error if the sign-in failed.
    func signIn(presentingViewController: UIViewController? = nil) -> AnyPublisher<(AuthDataResult?, GIDGoogleUser?), Error> {
        Future { [weak self, weak presentingViewController] promise in
            self?.signIn(presentingViewController: presentingViewController, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Signs the user in with Google, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: A publisher emitting the `AuthDataResult` if successful, or an error if the sign-in failed.
    func signIn(presentingViewController: UIViewController? = nil) -> AnyPublisher<GIDGoogleUser?, Error> {
        Future { [weak self, weak presentingViewController] promise in
            self?.signIn(presentingViewController: presentingViewController, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Link auth provider credentials to an existing user account.
    /// - Parameters  credential: An object of AuthCredential type.
    /// - Returns: A publisher emitting the `AuthDataResult` if successful, or an error if the linking failed.
    func link(with credential: AuthCredential) -> AnyPublisher<AuthDataResult?, Error> {
        Future { [weak self] promise in
            self?.link(with: credential, completion: promise)
        }
        .eraseToAnyPublisher()
    }
}
