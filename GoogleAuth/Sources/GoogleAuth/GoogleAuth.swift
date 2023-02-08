import BaseAuth
import GoogleSignIn
import FirebaseAuth

/// A class for handling Google authentication in your app.
public class GoogleAuth: BaseAuth {
    // MARK: - Public properties
    /// A shared instance of the class, allowing for a singleton pattern.
    public static let shared = GoogleAuth()
    
    /// The FirebaseAuth credential for the current user.
    var credential: AuthCredential? {
        guard let user = currentUser,
              let idToken = user.idToken else {
            return nil
        }

        return GoogleAuthProvider.credential(
            withIDToken: idToken.tokenString,
            accessToken: user.accessToken.tokenString
        )
    }
    
    /// The current user's Google user data.
    var currentUser: GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }
}

// MARK: - Public methods
public extension GoogleAuth {
    /// Restores the previous sign-in session, if it exists.
    /// - Parameter completion: A closure that will be called with the result of the restore attempt. The closure takes in a `Result` type, which can either be a `GIDGoogleUser` on success or an `Error` on failure.
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
    
    /// Signs the user in with Google and Firebase Auth, presenting a sign-in view controller if necessary.
    /// - Parameters:
    ///   - presentingViewController: The view controller to present the sign-in view controller from.
    ///   - completion: A closure that will be called with the result of the sign-in attempt. The closure takes in a `Result` type, which can either be a tuple of `(AuthDataResult?, GIDGoogleUser?)` on success or an `Error` on failure. 
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
    
    /// Signs the user in with Google, presenting a sign-in view controller if necessary.
    /// - Parameters:
    ///   - presentingViewController: The view controller to present the sign-in view controller from.
    ///   - completion: A closure that will be called with the result of the sign-in attempt. The closure takes in a `Result` type, which can either be a `GIDGoogleUser` on success or an `Error` on failure.
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
    /// - Returns: An error if there was a problem signing out, or `nil` if the sign-out was successful.
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
    
    /// Link auth provider credentials to an existing user account.
    /// - Parameters:
    ///   - credential: An object of AuthCredential type.
    ///   - completion: A closure that will be called with the result of the link attempt. The closure takes in a `Result` type, which can either be an `AuthDataResult` on success or an `Error` on failure.
    func link(with credential: AuthCredential, completion: ((Result<AuthDataResult?, Error>) -> Void)? = nil) {
        guard let user = Auth.auth().currentUser else {
            completion?(.failure(AuthError.notSignedInFirebaseAuth))
            return
        }
        
        user.link(with: credential) { result, error in
            if let error {
                completion?(.failure(error))
            } else {
                completion?(.success(result))
            }
        }
    }
}
