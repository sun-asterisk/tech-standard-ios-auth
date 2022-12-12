//
//  AuthManager.swift
//  AuthManager
//
//  Created by Tuan Truong on 28/11/2022.
//

import Foundation
import Combine

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

public protocol AuthManagerDelegate: AnyObject {
    func login(completion: @escaping (Token) -> Void, failure: @escaping (Error) -> Void)
    func refreshToken(token: String, completion: @escaping (Token) -> Void, failure: @escaping (Error) -> Void)
    func decodeToken(data: Data) -> Token?
}

public class AuthManager {
    public static let shared = AuthManager()
    
    public weak var delegate: AuthManagerDelegate?
    public var loginInfo: Any?
    
    private let tokenKey = "tokenKey"
    private let semaphore = DispatchSemaphore(value: 1)
    
    public func login(completion: @escaping () -> Void, failure: @escaping (Error) -> Void) {
        delegate?.login { [weak self] token in
            self?.saveToken(token)
            completion()
        } failure: { error in
            failure(error)
        }
    }
    
    private func saveToken(_ token: Token) {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.set(encoded, forKey: tokenKey)
        }
    }
    
    private func getToken() -> Token? {
        guard let data = UserDefaults.standard.object(forKey: tokenKey) as? Data else { return nil }
        return delegate?.decodeToken(data: data)
    }
    
    public func logout(completion: () -> Void) {
        cleanUp()
        completion()
    }
    
    public func fetchToken(completion: @escaping (Token?) -> Void) {
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
    
    public func cleanUp() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: tokenKey)
    }
}
