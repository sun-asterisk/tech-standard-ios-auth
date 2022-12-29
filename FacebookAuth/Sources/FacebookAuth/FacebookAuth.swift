import BaseAuth
import FacebookLogin
import FirebaseAuth

public enum FacebookAuthError: LocalizedError {
    case cancelled
    case noAccount
    case noAccessToken
    case notLogin
    
    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return NSLocalizedString("facebookAuth.error.cancelled",
                                     value: "User cancelled login.",
                                     comment: "")
        case .noAccount:
            return NSLocalizedString("facebookAuth.error.noAccount",
                                     value: "No account.",
                                     comment: "")
        case .noAccessToken:
            return NSLocalizedString("facebookAuth.error.noAccessToken",
                                     value: "No access token.",
                                     comment: "")
        case .notLogin:
            return NSLocalizedString("facebookAuth.error.notLogin",
                                     value: "Not login.",
                                     comment: "")
        }
    }
}

public class FacebookAuth: BaseAuth {
    // MARK: - Public properties
    
    /// A shared instance.
    public static let shared = FacebookAuth()
    
    /// Check if user is logged in.
    public var isLoggedIn: Bool {
        if let token = AccessToken.current,
           !token.isExpired {
            return true
        }
        
        return false
    }
    
    // MARK: - Private properties
    private let loginManager = LoginManager()
    
    /// Login Facebook and Firebase Auth.
    /// - Parameters:
    ///   - permissions: Facebook profile reading permissions
    ///   - fields: User's fields (id, name, ...). Reference: https://developers.facebook.com/docs/graph-api/reference/v3.2/user
    ///   - viewController: the presenting view controller
    ///   - completion: invoked when login completed or failed
    public func logIn(permissions: [Permission],
                      fields: String,
                      viewController: UIViewController?,
                      completion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)? = nil) {
        loginManager.logIn(permissions: permissions, viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                completion?(.failure(error))
            case .cancelled:
                completion?(.failure(FacebookAuthError.cancelled))
            case let .success(_, _, accessToken):
                guard let accessToken else {
                    completion?(.failure(FacebookAuthError.noAccessToken))
                    return
                }
                
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)

                Auth.auth().signIn(with: credential) { [weak self] (result, error) in
                    if let result {
                        self?.state = .signedIn
                        self?.method = .facebook
                        
                        GraphRequest(graphPath: "me", parameters: ["fields": fields])
                            .start(completionHandler: { (connection, requestResult, error) -> Void in
                                if let error {
                                    print(error)
                                    completion?(.success((result, nil)))
                                } else if let userInfo = requestResult as? [String: Any] {
                                    completion?(.success((result, userInfo)))
                                } else {
                                    completion?(.success((result, nil)))
                                }
                            })
                    } else if let error {
                        self?.reset()
                        completion?(.failure(error))
                    }
                }
            }
        }
    }
    
    /// Logout Facebook and Firebase Auth.
    /// - Returns: error if any
    public func logOut() -> Error? {
        loginManager.logOut()
        
        do {
            try Auth.auth().signOut()
            reset()
            return nil
        } catch {
            return error
        }
    }
    
    /// Get current access token.
    /// - Returns: current access token
    public func getAccessToken() -> AccessToken? {
        AccessToken.current
    }
    
    /// Get user information.
    /// - Parameters:
    ///   - fields: User's fields (id, name, ...). Reference: https://developers.facebook.com/docs/graph-api/reference/v3.2/user
    ///   - completion: invoked when getting user info completed or failed
    public func getUserInfo(fields: String,
                            completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
        guard isLoggedIn else {
            completion(.failure(FacebookAuthError.notLogin))
            return
        }
        
        GraphRequest(graphPath: "me", parameters: ["fields": fields])
            .start(completionHandler: { (connection, requestResult, error) -> Void in
                if let error {
                    completion(.failure(error))
                } else if let userInfo = requestResult as? [String: Any] {
                    completion(.success(userInfo))
                } else {
                    completion(.success(nil))
                }
            })
    }
}
