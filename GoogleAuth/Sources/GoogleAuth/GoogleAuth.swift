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
    
    public override func setSignInState() {
        state = .signedIn
        method = .google
    }
}

// MARK: - Public methods
public extension GoogleAuth {
    /// Restores the previous sign-in session, if it exists.
    ///
    /// This function can be used to restore a previous sign-in session for a user, and it provides a mechanism for handling both successful and failed restore attempts using a closure-based API.
    ///
    /// - Parameter completion: A closure that will be called with the result of the restore attempt. The closure takes in a `Result` type, which can either be a `GIDGoogleUser` on success or an `Error` on failure.
    func restorePreviousSignIn(completion: ((Result<GIDGoogleUser, Error>) -> Void)? = nil) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { [weak self] user, error in
            if let user {
                self?.setSignInState()
                completion?(.success(user))
            } else if let error {
                completion?(.failure(error))
            }
        }
    }
    
    /// Signs the user in with Google and Firebase Auth, presenting a sign-in view controller if necessary.
    ///
    /// This function can be used to sign in a user with Google and Firebase Auth, and provides a mechanism for handling both successful and failed sign-in attempts using a closure-based API. Additionally, it also allows for presenting the sign-in view controller if needed.
    ///
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
                guard let self else { return }
                
                if let result {
                    self.setSignInState()
                    completion?(.success((result, user)))
                } else if let error {
                    self.signOutGoogle()
                    self.resetSignInState()
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
    ///
    /// This function can be used to sign in a user with Google Sign-In, and provides a mechanism for handling both successful and failed sign-in attempts using a closure-based API. Additionally, it also allows for presenting the sign-in view controller if needed.
    ///
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
                setSignInState()
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
    ///
    /// This function is to provide a simple mechanism for signing out a user from both Google and Firebase Auth. This can be useful in scenarios where a user wants to log out of an application or switch to a different account.
    ///
    /// - Returns: An error if there was a problem signing out, or `nil` if the sign-out was successful.
    func signOut() -> Error? {
        if Auth.auth().currentUser != nil, let error = signOutFirebase() {
            return error
        }
        
        signOutGoogle()
        resetSignInState()
        
        return nil
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

// MARK: - Private methods
private extension GoogleAuth {
    func signOutGoogle() {
        GIDSignIn.sharedInstance.signOut()
    }
    
    @discardableResult
    func signOutFirebase() -> Error? {
        do {
            try Auth.auth().signOut()
            return nil
        } catch {
            return error
        }
    }
}
