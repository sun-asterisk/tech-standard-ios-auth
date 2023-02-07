import BaseAuth
import Foundation

/// An object that manages credential-based authentication.
public class CredentialAuth: BaseAuth {
    // MARK: - Public properties
    /// A shared instance.
    public static let shared = CredentialAuth()
    
    /// An object that acts as the delegate of the auth manager.
    public weak var delegate: (any CredentialAuthDelegate)?
    
    // MARK: - Private properties
    private static let tokenKey = "CREDENTIAL_AUTH_TOKEN_KEY"
    private static let userKey = "CREDENTIAL_AUTH_USER_KEY"
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    public override init() {
        super.init()
    }
    
    public override func resetSignInState() {
        super.resetSignInState()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: CredentialAuth.tokenKey)
        defaults.removeObject(forKey: CredentialAuth.userKey)
    }
    
    public override func cleanUp() {
        super.cleanUp()
        self.resetSignInState()
    }
}

// MARK: - public methods
public extension CredentialAuth {
    /// Login using the provided credentials.
    ///
    /// The purpose of the function is to perform the login process using the provided credentials. If the authentication is successful, the completion closure will be called with a `Result` that has a `Void` value, indicating that the operation was successful. If the authentication fails, the completion closure will be called with a `Result` that has an `Error` value, indicating that the operation failed and providing information about the failure.
    ///
    /// The `completion` closure is optional and can be omitted if the caller does not need to be notified of the result of the authentication request.
    ///
    /// - Parameters:
    ///   - credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for authentication.
    ///   - completion: An optional closure is called when the operation is complete.
    func login(credential: [String: Any], completion: ((Result<Void, Error>) -> Void)? = nil) {
        delegate?.login(credential: credential) { [weak self] token, user in
            self?.saveToken(token)
            
            if let user {
                self?.saveUser(user)
            }
            
            self?.state = .signedIn
            self?.method = .credential
            
            completion?(.success(()))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// Logout.
    ///
    /// The purpose of the function is to perform the logout process. If the logout is successful, the completion closure will be called with a `Result` that has a `Void` value, indicating that the operation was successful. If the logout fails, the completion closure will be called with a `Result` that has an `Error` value, indicating that the operation failed and providing information about the failure.
    ///
    /// The `completion` closure is optional and can be omitted if the caller does not need to be notified of the result of the logout request. The `credential` parameter is also optional and can be omitted if the logout process does not require any credentials.
    ///
    /// - Parameters:
    ///   - credential: A optional dictionary with a `String` key and an `Any` value, which represents the user's credentials for logging out.
    ///   - completion: An optional closure is called when the operation is complete.
    func logout(credential: [String : Any]? = nil, completion: ((Result<Void, Error>) -> Void)? = nil) {
        delegate?.logout(credential: credential) { [weak self] in
            self?.resetSignInState()
            completion?(.success(()))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// Get token.
    ///
    /// The purpose of the function is to retrieve the authentication token, represented by a conforming type to the `AuthToken` protocol. The function returns the authentication token to the caller, which can then be used to make authenticated requests.
    ///
    /// - Returns: An optional object conforming to the `AuthToken` protocol, return `nil` if no authentication token is available.
    func getToken() -> AuthToken? {
        guard let data = UserDefaults.standard.object(forKey: CredentialAuth.tokenKey) as? Data else { return nil }
        return delegate?.decodeToken(data: data)
    }
    
    /// Get token.
    ///
    /// The purpose of the function is to retrieve the authentication token and pass the result of the operation to the caller using the completion closure. If the authentication token is available and valid, the function will pass the token to the caller as a `Result` with a value of `AuthToken`. If the authentication token is not available or has expired, the function may delegate the task of refreshing the token to another object, which would be responsible for retrieving a new token.
    ///
    /// - Parameters:
    ///   - checkTokenExpiration: A boolean value that indicates whether to check the expiration of the token. If `checkTokenExpiration` is set to `false`, then the function will always call the refresh token.
    ///   - completion: A closure is called when the operation is complete.
    func getToken(checkTokenExpiration: Bool = true, completion: @escaping (Result<AuthToken, Error>) -> Void) {
        DispatchQueue(label: "Get token").async { [weak self] in
            self?.semaphore.wait()
            
            if let token = self?.getToken() {
                if checkTokenExpiration && !token.isExpired {
                    completion(.success(token))
                    self?.semaphore.signal()
                } else {
                    self?.delegate?.refreshToken(refreshToken: token.refreshToken) { token in
                        self?.saveToken(token)
                        completion(.success(token))
                        self?.semaphore.signal()
                    } failure: { error in
                        completion(.failure(error))
                        self?.semaphore.signal()
                    }
                }
            } else {
                completion(.failure(AuthError.noToken))
                self?.semaphore.signal()
            }
        }
    }
    
    /// Get user.
    ///
    /// The purpose of the function is to retrieve the saved user information. If a user has been saved, the function returns the saved user as an optional `Codable` object. If a user has not been saved, the function returns `nil`.
    ///
    /// - Returns: The saved user that conforms to the `Codable` protocol.
    func getUser() -> Codable? {
        guard let data = UserDefaults.standard.object(forKey: CredentialAuth.userKey) as? Data else { return nil }
        return delegate?.decodeUser(data: data)
    }
}

// MARK: - Private methods
private extension CredentialAuth {
    func saveToken(_ token: AuthToken) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.set(encoded, forKey: CredentialAuth.tokenKey)
        }
    }
    
    func saveUser(_ user: Codable) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: CredentialAuth.userKey)
        }
    }
}
