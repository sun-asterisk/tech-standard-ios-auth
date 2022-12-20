import BaseAuth
import Foundation

/// An object that manages access tokens.
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
    
    public override func logout(credential: [String : Any]?, completion: ((Bool, Error?) -> Void)? = nil) {
        super.logout(credential: credential, completion: completion)
        
        delegate?.logout(credential: credential) { [weak self] success, error in
            if success {
                self?.cleanUp()
                self?.state = .signedOut
            }
            
            completion?(success, error)
        }
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
    func login(credential: [String: Any]? = nil, completion: ((Bool, Error?) -> Void)? = nil) {
        delegate?.login(credential: credential) { [weak self] token, user, error in
            if let token {
                self?.saveToken(token)
                
                if let user {
                    self?.saveUser(user)
                }
                
                self?.state = .signedIn
                completion?(true, nil)
            } else if let error {
                completion?(false, error)
            }
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
    func getToken(completion: @escaping (AuthToken?, Error?) -> Void) {
        DispatchQueue(label: "Fetch token").async { [weak self] in
            self?.semaphore.wait()
            
            if let token = self?.getToken() {
                if !token.isExpired {
                    completion(token, nil)
                    self?.semaphore.signal()
                } else {
                    self?.delegate?.refreshToken(token: token.refreshToken) { token, error in
                        if let token {
                            self?.saveToken(token)
                            completion(token, nil)
                            self?.semaphore.signal()
                        } else if let error {
                            completion(nil, error)
                            self?.semaphore.signal()
                        }
                    }
                }
            } else {
                completion(nil, AuthError.noToken)
                self?.semaphore.signal()
            }
        }
    }
    
    /// Get user.
    /// - Returns: the user if any
    func getUser() -> AuthUser? {
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
    
    func saveUser(_ user: AuthUser) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }
}
