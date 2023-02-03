import Foundation

/// Methods for logging in, logging out and refreshing token.
public protocol CredentialAuthDelegate: AnyObject {
    /// A token type.
    associatedtype T: AuthToken
    
    /// An user type.
    associatedtype U: Codable
    
    /// Login using the provided credentials.
    /// 
    ///The function is a delegate function and its purpose is to initiate a login process using the provided credential information.
    ///
    /// - Parameters:
    ///   - credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for authentication.
    ///   - success: A closure will be called if the login process is successful and will receive two parameters: a token of type `T` and an optional user of type `U?`.
    ///   - failure: A closure will be called if the login process fails and will receive one parameter, an `Error` object, that provides information about the failure.
    func login(credential: [String: Any], success: @escaping (T, U?) -> Void, failure: @escaping (Error) -> Void)
    
    /// Refresh token.
    ///
    /// The function is a delegate function and its purpose is to initiate a token refresh process using the provided `refreshToken` information.
    ///
    /// - Parameters:
    ///   - refreshToken: A string that represents the refresh token to be used to refresh the access token.
    ///   - success: A closure or function that takes one parameter of type `T` and returns nothing. This closure will be called if the refresh process is successful.
    ///   - failure: A closure or function that takes one parameter of type `Error`, and returns nothing. This closure will be called if the refresh process fails.
    func refreshToken(refreshToken: String, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void)
    
    /// Call logout API.
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    
    /// Logout.
    ///
    /// The function is a delegate function and its purpose is to initiate the logout process for the user.
    ///
    /// - Parameters:
    ///   - credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for logging out.
    ///   - success: An optional closure or function that takes no parameters and returns nothing. This closure will be called if the logout process is successful.
    ///   - failure: An optional closure or function that takes one parameter of type `Error`, and returns nothing. This closure will be called if the logout process fails.
    func logout(credential: [String: Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?)
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
