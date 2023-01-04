import BaseAuth
import FacebookLogin
import FirebaseAuth

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

    // FBLoginButton (UIKit)
    private weak var loginButton: FBLoginButton?
    private var userFields = ""
    private var loginCompletion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)?
    private var logoutCompletion: ((Error?) -> Void)?
    
    // MARK: - Override
    
    public override func reset() {
        super.reset()
    }
}

// MARK: - Public methods
public extension FacebookAuth {
    
    /// Login Facebook and Firebase Auth.
    /// - Parameters:
    ///   - permissions: Facebook profile reading permissions
    ///   - fields: User's fields (id, name, ...). Reference: https://developers.facebook.com/docs/graph-api/reference/v3.2/user
    ///   - viewController: the presenting view controller
    ///   - completion: invoked when login completed or failed
    func logIn(permissions: [Permission],
               fields: String,
               viewController: UIViewController?,
               completion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)? = nil) {
        loginManager.logIn(permissions: permissions, viewController: viewController) { [weak self] loginResult in
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
                
                self?.loginFirebaseAuth(accessToken: accessToken, fields: fields, completion: completion)
            }
        }
    }
    
    /// Logout Facebook and Firebase Auth.
    /// - Returns: error if any
    func logout() -> Error? {
        loginManager.logOut()
        return logoutFirebase()
    }
    
    /// Get current access token.
    /// - Returns: current access token
    func getAccessToken() -> AccessToken? {
        AccessToken.current
    }
    
    /// Get user information.
    /// - Parameters:
    ///   - fields: User's fields (id, name, ...). Reference: https://developers.facebook.com/docs/graph-api/reference/v3.2/user
    ///   - completion: invoked when getting user info completed or failed
    func getUserInfo(fields: String,
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
    
    /// Set delegate for FBLoginButton.
    /// - Parameters:
    ///   - button: a FBLoginButton
    ///   - fields: User's fields (id, name, ...). Reference: https://developers.facebook.com/docs/graph-api/reference/v3.2/user
    ///   - loginCompletion: invoked when login completed or failed
    ///   - logoutCompletion: invoked when logout completed or failed
    func setDelegate(for button: FBLoginButton,
                     fields: String,
                     loginCompletion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)? = nil,
                     logoutCompletion: ((Error?) -> Void)? = nil) {
        button.delegate = self
        self.loginButton = button
        self.userFields = fields
        self.loginCompletion = loginCompletion
        self.logoutCompletion = logoutCompletion
    }
    
    /// Remove delegate for FBLoginButton.
    /// - Parameter button: a FBLoginButton
    func removeDelegate(for button: FBLoginButton? = nil) {
        button?.delegate = nil
        userFields = ""
        loginButton?.delegate = nil
        loginButton = nil
        loginCompletion = nil
        logoutCompletion = nil
    }
}

// MARK: - Private methods
private extension FacebookAuth {
    func loginFirebaseAuth(accessToken: AccessToken,
                           fields: String,
                           completion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)?) {
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
    
    func logoutFirebase() -> Error? {
        do {
            try Auth.auth().signOut()
            reset()
            return nil
        } catch {
            return error
        }
    }
}

// MARK: - LoginButtonDelegate
extension FacebookAuth: LoginButtonDelegate {
    public func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if let error {
            loginCompletion?(.failure(error))
        } else if let result {
            if result.isCancelled {
                loginCompletion?(.failure(FacebookAuthError.cancelled))
            } else {
                guard let accessToken = result.token else {
                    loginCompletion?(.failure(FacebookAuthError.noAccessToken))
                    return
                }
                
                loginFirebaseAuth(accessToken: accessToken, fields: userFields, completion: loginCompletion)
            }
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        let error = logoutFirebase()
        logoutCompletion?(error)
    }
}
