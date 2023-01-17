import BaseAuth
import FacebookLogin
import FirebaseAuth

/// A class that allows users to log in to an iOS app using their Facebook credentials.
public class FacebookAuth: BaseAuth {
    // MARK: - Public properties
    
    /// A shared instance of FacebookAuth.
    public static let shared = FacebookAuth()
    
    /// A variable that is used to check if a user is logged in or not.
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
    private var loginFacebookAndFirebaseAuthCompletion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)?
    private var loginFacebookCompletion: ((Result<[String: Any]?, Error>) -> Void)?
    private var logoutCompletion: ((Error?) -> Void)?
    private var usingFirebaseAuth = false
    
    // MARK: - Override
    
    public override func resetSignInState() {
        super.resetSignInState()
    }
}

// MARK: - Public methods
public extension FacebookAuth {
    
    /// Login Facebook and Firebase Authentication.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user. After the user grants the permissions, the function logs in to Firebase Authentication and retrieves the user's auth data and additional fields and returns them in the completion handler. The completion handler is optional and will only be called if provided. The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    ///   - completion: An optional closure that is called when the login process is completed. The completion handler takes a `Result` object, which contains either an `AuthDataResult` object and a dictionary of the fields returned for the user,  or an error if the login failed.
    func login(permissions: [Permission],
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
    
    /// Login Facebook.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user. After the user grants the permissions, the function retrieves the user's fields and returns them in the completion handler. The completion handler is optional and will only be called if provided. The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    ///   - completion: An optional closure that is called when the login process is completed. The closure takes a single argument of type Result<[String: Any]?, Error>, where the .success case includes a dictionary of the fields returned for the user, and the .failure case contains an error object describing the failure.
    func login(permissions: [Permission],
               fields: String,
               viewController: UIViewController?,
               completion: ((Result<[String: Any]?, Error>) -> Void)? = nil) {
        loginManager.logIn(permissions: permissions, viewController: viewController) { [weak self] loginResult in
            switch loginResult {
            case .failed(let error):
                completion?(.failure(error))
            case .cancelled:
                completion?(.failure(FacebookAuthError.cancelled))
            case .success:
                self?.getUserInfo(fields: fields) { completion?($0) }
            }
        }
    }
    
    /// Logout Facebook and Firebase Authentication.
    ///
    /// This function uses the Facebook SDK to log out the user from their Facebook account and clear the session data. It should be called when the user wants to log out from the app. This function will also clear the Firebase Authentication user if it was logged in using Facebook.
    ///
    /// - Returns: An optional Error object, which will be nil if the logout is successful, or contain an error message if there was a problem logging out.
    func logout() -> Error? {
        loginManager.logOut()
        return logoutFirebaseAuth()
    }
    
    /// Get the Facebook Access Token of the currently logged-in user.
    ///
    /// This function is used to retrieve the user's access token. The function should be called when the user is logged in successfully.
    ///
    /// - Returns: An AccessToken object, which holds the user's access token. If the user is not logged in or the token is not available, it returns nil.
    func getAccessToken() -> AccessToken? {
        AccessToken.current
    }
    
    /// Fetches the user's information from Facebook.
    ///
    /// This function uses the Facebook SDK to make a request to the Facebook Graph API to fetch the user's information based on the fields provided and returns the data in the completion handler. The completion handler is mandatory and should be provided to handle the response, the function should be called when the user is logged in successfully.
    ///
    /// - Parameters:
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - completion: A completion handler that gets called after the user's information has been retrieved.
    func getUserInfo(fields: String,
                     completion: @escaping (Result<[String: Any]?, Error>) -> Void) {
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
    
    /// Sets the delegate for a given Facebook login button.
    ///
    /// This function sets the delegate for the given button and allows for handling of login and logout events, returns user's additional fields and also handles the Firebase Authentication. The completion handlers are optional and will only be called if provided.
    ///
    /// - Parameters:
    ///   - button: An instance of the `FBLoginButton` class that represents the button on which the delegate is set.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - loginCompletion: A completion handler that gets called after a successful login and returns the user's auth data and additional fields.
    ///   - logoutCompletion: A completion handler that gets called after a successful logout and returns any error that might occur.
    func setDelegate(for button: FBLoginButton,
                     fields: String,
                     loginCompletion: ((Result<(AuthDataResult, [String: Any]?), Error>) -> Void)? = nil,
                     logoutCompletion: ((Error?) -> Void)? = nil) {
        button.delegate = self
        self.loginButton = button
        self.userFields = fields
        self.usingFirebaseAuth = true
        self.loginFacebookAndFirebaseAuthCompletion = loginCompletion
        self.logoutCompletion = logoutCompletion
    }
    
    /// Sets the delegate for a given Facebook login button.
    ///
    /// This function sets the delegate for the given button and allows for handling of login and logout events, returns user's additional fields. The completion handlers are optional and will only be called if provided.
    ///
    /// - Parameters:
    ///   - button: An instance of the `FBLoginButton` class that represents the button on which the delegate is set.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - loginCompletion: A completion handler that gets called after a successful login and returns the user's auth data and additional fields.
    ///   - logoutCompletion: A completion handler that gets called after a successful logout and returns any error that might occur.
    func setDelegate(for button: FBLoginButton,
                     fields: String,
                     loginCompletion: ((Result<[String: Any]?, Error>) -> Void)? = nil,
                     logoutCompletion: ((Error?) -> Void)? = nil) {
        button.delegate = self
        self.loginButton = button
        self.userFields = fields
        self.usingFirebaseAuth = true
        self.loginFacebookCompletion = loginCompletion
        self.logoutCompletion = logoutCompletion
    }
    
    /// Removes the delegate for a given Facebook login button.
    ///
    /// This function removes the delegate from the given button and stop handling the login/logout events. This function should be called when the button is no longer needed or when the user is logging out.
    ///
    /// - Parameter button: An instance of the `FBLoginButton` class that represents the button from which the delegate is to be removed, it is optional and if not provided it will remove the delegate from the current button.
    func removeDelegate(for button: FBLoginButton? = nil) {
        button?.delegate = nil
        userFields = ""
        loginButton?.delegate = nil
        loginButton = nil
        usingFirebaseAuth = false
        loginFacebookAndFirebaseAuthCompletion = nil
        loginFacebookCompletion = nil
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
                
                self?.getUserInfo(fields: fields, completion: { getUserInfoResult in
                    switch getUserInfoResult {
                    case .success(let userInfo):
                        completion?(.success((result, userInfo)))
                    case .failure:
                        completion?(.success((result, nil)))
                    }
                })
            } else if let error {
                self?.resetSignInState()
                completion?(.failure(error))
            }
        }
    }
    
    func logoutFirebaseAuth() -> Error? {
        do {
            try Auth.auth().signOut()
            resetSignInState()
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
            if usingFirebaseAuth {
                loginFacebookAndFirebaseAuthCompletion?(.failure(error))
            } else {
                loginFacebookCompletion?(.failure(error))
            }
        } else if let result {
            if result.isCancelled {
                if usingFirebaseAuth {
                    loginFacebookAndFirebaseAuthCompletion?(.failure(FacebookAuthError.cancelled))
                } else {
                    loginFacebookCompletion?(.failure(FacebookAuthError.cancelled))
                }
            } else {
                guard let accessToken = result.token else {
                    if usingFirebaseAuth {
                        loginFacebookAndFirebaseAuthCompletion?(.failure(FacebookAuthError.noAccessToken))
                    } else {
                        loginFacebookCompletion?(.failure(FacebookAuthError.noAccessToken))
                    }
                    
                    return
                }
                
                if usingFirebaseAuth {
                    loginFirebaseAuth(accessToken: accessToken, fields: userFields, completion: loginFacebookAndFirebaseAuthCompletion)
                } else {
                    getUserInfo(fields: userFields) { [weak self] getUserInfoResult in
                        switch getUserInfoResult {
                        case .success(let userInfo):
                            self?.loginFacebookCompletion?(.success(userInfo))
                        case .failure(let error):
                            self?.loginFacebookCompletion?(.failure(error))
                        }
                    }
                }
            }
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        if usingFirebaseAuth {
            let error = logoutFirebaseAuth()
            logoutCompletion?(error)
        } else {
            logoutCompletion?(nil)
        }
    }
}
