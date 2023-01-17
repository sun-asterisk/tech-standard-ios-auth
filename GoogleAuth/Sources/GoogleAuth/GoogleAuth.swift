import BaseAuth
import GoogleSignIn
import FirebaseAuth

/// An object that manages Google Sign-in authentication.
public class GoogleAuth: BaseAuth {
    // MARK: - Public properties
    /// A shared instance.
    public static let shared = GoogleAuth()
}

// MARK: - Public methods
public extension GoogleAuth {
    
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Parameter completion: invoked when restore completed or failed
    func restorePreviousSignIn(completion: ((Result<GIDGoogleUser, Error>) -> Void)? = nil) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user {
                self?.state = .signedIn
                self?.method = .google
                completion?(.success(user))
            } else if let error {
                completion?(.failure(error))
            }
        }
    }
    
    func getUser() -> GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }
    
    /// Sign-in Google and Firebase Auth.
    /// - Parameters:
    ///   - presentingViewController: the presenting view controller
    ///   - completion: invoked when sign in completed or failed
    func signIn(presentingViewController: UIViewController? = nil,
                completion: ((Result<(AuthDataResult?, GIDGoogleUser?), Error>) -> Void)? = nil) {
        
        func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            if let error {
                resetSignInState()
                completion?(.failure(error))
                return
            }
            
            guard let accessToken = user?.accessToken, let idToken = user?.idToken else {
                resetSignInState()
                completion?(.failure(AuthError.noToken))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                if let result {
                    self?.state = .signedIn
                    self?.method = .google
                    completion?(.success((result, user)))
                } else if let error {
                    self?.resetSignInState()
                    completion?(.failure(error))
                }
            }
        }
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            let viewController: UIViewController?
            
            if #available(iOS 13.0, *) {
                viewController = presentingViewController
                ?? (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
            } else {
                viewController = presentingViewController
                ?? UIApplication.shared.keyWindow?.rootViewController
            }
            
            guard let viewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                authenticateUser(for: result?.user, with: error)
            }
        }
    }
    
    /// Sign-in Google .
    /// - Parameters:
    ///   - presentingViewController: the presenting view controller
    ///   - completion: invoked when sign in completed or failed
    func signIn(presentingViewController: UIViewController? = nil,
                completion: ((Result<GIDGoogleUser?, Error>) -> Void)? = nil) {
        func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            if let error {
                resetSignInState()
                completion?(.failure(error))
            } else {
                state = .signedIn
                method = .google
                completion?(.success(user))
            }
        }
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            let viewController: UIViewController?
            
            if #available(iOS 13.0, *) {
                viewController = presentingViewController
                ?? (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
            } else {
                viewController = presentingViewController
                ?? UIApplication.shared.keyWindow?.rootViewController
            }
            
            guard let viewController else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
                authenticateUser(for: result?.user, with: error)
            }
        }
    }
    
    /// Sign out Google and Firebase Auth.
    /// - Returns: error if any
    func signOut() -> Error? {
        GIDSignIn.sharedInstance.signOut()
        
        // Check Firebase login state
        guard Auth.auth().currentUser != nil else { return nil }

        do {
            try Auth.auth().signOut()
            resetSignInState()
            return nil
        } catch {
            return error
        }
    }
}
