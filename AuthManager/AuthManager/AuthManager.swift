//
//  AuthManager.swift
//  AuthManager
//
//  Created by Tuan Truong on 28/11/2022.
//

import Foundation
import Combine

/// A protocol that contains access token, refresh token and expired date.
public protocol Token: Codable {
    var accessToken: String { get }
    var refreshToken: String { get }
    var expiredDate: Date { get }
}

public extension Token {
    var isExpired: Bool {
        expiredDate < Date()
    }
}

/// Methods for logging in and refreshing token.
public protocol AuthManagerDelegate: AnyObject {
    associatedtype T: Token
    
    /// Call login API.
    /// - Parameters:
    ///   - completion: invoked when login completed
    ///   - failure: invoked when login failed
    func login(completion: @escaping (T) -> Void, failure: @escaping (Error) -> Void)
    
    /// Call refresh token API.
    /// - Parameters:
    ///   - token: refresh token
    ///   - completion: invoked when refresh token completed
    ///   - failure: invoked when refresh token failed
    func refreshToken(token: String, completion: @escaping (T) -> Void, failure: @escaping (Error) -> Void)
}

extension AuthManagerDelegate {
    func decodeToken(data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
}

/// An object that manages access tokens.
public class AuthManager {
    // MARK: - Public properties
    /// A shared instance.
    public static let shared = AuthManager()
    
    /// An object that acts as the delegate of the auth manager.
    public weak var delegate: (any AuthManagerDelegate)?
    
    /// An object that contains login info such as email and password.
    public var loginInfo: Any?
    
    // MARK: - Private properties
    private let tokenKey = "tokenKey"
    private let semaphore = DispatchSemaphore(value: 1)
}

// MARK: - public methods
public extension AuthManager {
    /// Call delegate's login method then save returned token.
    /// - Parameters:
    ///   - completion: invoked when login completed
    ///   - failure: invoked when login failed
    func login(completion: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        delegate?.login { [weak self] token in
            self?.saveToken(token)
            completion()
        } failure: { error in
            failure(error)
        }
    }
    
    /// Clean up saved data.
    func cleanUp() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
    }
    
    /// Get token, call refresh token if needs.
    /// - Parameter completion: invoked when getting token completed, return nil if getting token failed
    func fetchToken(completion: @escaping (Token?) -> Void) {
        DispatchQueue(label: "Fetch token").async { [weak self] in
            self?.semaphore.wait()
            
            if let token = self?.getToken() {
                if !token.isExpired {
                    completion(token)
                    self?.semaphore.signal()
                } else {
                    self?.delegate?.refreshToken(token: token.refreshToken) { token in
                        self?.saveToken(token)
                        completion(token)
                        self?.semaphore.signal()
                    } failure: { error in
                        completion(nil)
                        self?.semaphore.signal()
                    }
                }
            } else {
                completion(nil)
                self?.semaphore.signal()
            }
        }
    }
}

// MARK: - Private methods
private extension AuthManager {
    func saveToken(_ token: Token) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.set(encoded, forKey: tokenKey)
        }
    }
    
    func getToken() -> Token? {
        guard let data = UserDefaults.standard.object(forKey: tokenKey) as? Data else { return nil }
        return delegate?.decodeToken(data: data)
    }
}
