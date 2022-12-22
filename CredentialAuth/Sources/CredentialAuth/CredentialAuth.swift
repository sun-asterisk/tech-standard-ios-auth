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
    private let tokenKey = "AUTH_TOKEN_KEY"
    private let userKey = "AUTH_USER_KEY"
    
    private let semaphore = DispatchSemaphore(value: 1)
    
    public override init() {
        super.init()
    }
    
    public override func cleanUp() {
        super.cleanUp()
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
        defaults.removeObject(forKey: userKey)
    }
}

// MARK: - public methods
public extension CredentialAuth {
    /// Call delegate's login method then save returned token.
    /// - Parameters:
    ///   - credential: user name or e-mail address, in combination with a password
    ///   - completion: invoked when login completed
    func login(credential: [String: Any], completion: ((Result<Void, Error>) -> Void)? = nil) {
        delegate?.login(credential: credential) { [weak self] token, user in
            self?.saveToken(token)
            
            if let user {
                self?.saveUser(user)
            }
            
            self?.state = .signedIn
            completion?(.success(()))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// Logout then clean up saved data.
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    func logout(credential: [String : Any]?, completion: ((Result<Void, Error>) -> Void)? = nil) {
        delegate?.logout(credential: credential) { [weak self] in
            self?.cleanUp()
            self?.state = .signedOut
            completion?(.success(()))
        } failure: { error in
            completion?(.failure(error))
        }
    }
    
    /// Get token.
    /// - Returns: the saved token if any
    func getToken() -> AuthToken? {
        guard let data = UserDefaults.standard.object(forKey: tokenKey) as? Data else { return nil }
        return delegate?.decodeToken(data: data)
    }
    
    /// Get token, call refresh token if needs.
    /// - Parameter completion: invoked when getting token completed
    func getToken(completion: @escaping (Result<AuthToken, Error>) -> Void) {
        DispatchQueue(label: "Get token").async { [weak self] in
            self?.semaphore.wait()
            
            if let token = self?.getToken() {
                if !token.isExpired {
                    completion(.success(token))
                    self?.semaphore.signal()
                } else {
                    self?.delegate?.refreshToken(token: token.refreshToken) { token in
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
    /// - Returns: the user if any
    func getUser() -> Codable? {
        guard let data = UserDefaults.standard.object(forKey: userKey) as? Data else { return nil }
        return delegate?.decodeUser(data: data)
    }
}

// MARK: - Private methods
private extension CredentialAuth {
    func saveToken(_ token: AuthToken) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.set(encoded, forKey: tokenKey)
        }
    }
    
    func saveUser(_ user: Codable) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
}
