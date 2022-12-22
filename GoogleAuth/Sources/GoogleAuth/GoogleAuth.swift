import BaseAuth
import GoogleSignIn
import FirebaseAuth

/// An object that manages Google Sign-in authentication.
public class GoogleAuth: BaseAuth {
    // MARK: - Public properties
    /// A shared instance.
    public static let shared = GoogleAuth()
    
    public override init() {
        super.init()
    }
    
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Parameter completion: invoked when restore completed or failed
    public func restorePreviousSignIn(completion: ((Result<GIDGoogleUser, Error>) -> Void)? = nil) {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let user {
                self.state = .signedIn
                completion?(.success(user))
            } else if let error {
                self.state = .signedOut
                completion?(.failure(error))
            }
        }
    }
    
    public func getUser() -> GIDGoogleUser? {
        GIDSignIn.sharedInstance.currentUser
    }
    
    /// This method should be called from your UIApplicationDelegate’s application:openURL:options: method.
    /// - Parameter url: the url
    /// - Returns: return false if not handled by this app
    public func handle(_ url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    /// Starts an interactive sign-in flow on iOS.
    /// - Parameters:
    ///   - presentingViewController: the presenting view controller
    ///   - completion: invoked when sign in completed or failed
    public func signIn(presentingViewController: UIViewController? = nil,
                       completion: ((Result<(AuthDataResult?, GIDGoogleUser?), Error>) -> Void)? = nil) {
        
        func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            if let error = error {
                state = .signedOut
                completion?(.failure(error))
                return
            }
            
            guard let accessToken = user?.accessToken, let idToken = user?.idToken else {
                state = .signedOut
                completion?(.failure(AuthError.noToken))
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                if let result {
                    self?.state = .signedIn
                    completion?(.success((result, user)))
                } else if let error {
                    self?.state = .signedOut
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
    
    /// Sign out Google and Firebase Auth
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    public func signOut(completion: ((Result<Void, Error>) -> Void)? = nil) {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            super.cleanUp()
            state = .signedOut
            completion?(.success(()))
        } catch {
            completion?(.failure(error))
        }
    }
}