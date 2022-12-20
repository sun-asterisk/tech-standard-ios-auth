import Foundation

/// Methods for logging in and refreshing token.
public protocol CredentialAuthDelegate: AnyObject {
    associatedtype T: AuthToken
    associatedtype U: AuthUser
    
    /// Call login API.
    /// - Parameters:
    ///   - credential: user name or e-mail address, in combination with a password
    ///   - completion: invoked when login completed
    func login(credential: [String: Any]?, completion: @escaping (T?, U?, Error?) -> Void)
    
    /// Call refresh token API.
    /// - Parameters:
    ///   - token: refresh token
    ///   - completion: invoked when refresh token completed
    func refreshToken(token: String, completion: @escaping (T?, Error?) -> Void)
    
    /// Call logout API.
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    func logout(credential: [String: Any]?, completion: @escaping (Bool, Error?) -> Void)
}

internal extension CredentialAuthDelegate {
    func decodeToken(data: Data) -> T? {
        let decoder = JSONDecoder()
        return try? decoder.decode(T.self, from: data)
    }
    
    func decodeUser(data: Data) -> U? {
        let decoder = JSONDecoder()
        return try? decoder.decode(U.self, from: data)
    }
}
