import Combine
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: an AnyPublisher containing the signed-in user
    func restorePreviousSignIn() -> AnyPublisher<GIDGoogleUser, Error> {
        Future { [weak self] promise in
            self?.restorePreviousSignIn(completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Starts an interactive sign-in flow on iOS.
    /// - Parameter presentingViewController: the presenting view controller
    /// - Returns: an AnyPublisher containing sign-in results
    func signIn(presentingViewController: UIViewController? = nil) -> AnyPublisher<(AuthDataResult?, GIDGoogleUser?), Error> {
        Future { [weak self, weak presentingViewController] promise in
            self?.signIn(presentingViewController: presentingViewController, completion: promise)
        }
        .eraseToAnyPublisher()
    }
}