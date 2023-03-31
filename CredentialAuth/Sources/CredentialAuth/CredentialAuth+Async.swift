import Foundation

public extension CredentialAuth {
    /// Login using the provided credentials.
    ///
    /// The purpose of the function is to initiate a login process using the provided credential information. The credential parameter is a dictionary that contains the necessary information for the login process, such as a username and password.
    ///
    /// The function returns a `Result` value that indicates the success or failure of the login operation. If the operation is successful, the function returns a `Result` with a value of `Void`. If the operation fails, the function returns a `Result` with an `Error` value that provides information about the failure.
    /// 
    /// - Parameter credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for authentication.
    /// - Returns: A `Result` value that indicates the success or failure of the login operation.
    func login(credential: [String: Any]) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            login(credential: credential, completion: continuation.resume(returning:))
        }
    }
    
    func loginWithBiometrics(reason: String) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            loginWithBiometrics(reason: reason, completion: continuation.resume(returning:))
        }
    }
    
    /// Logout.
    ///
    /// The purpose of the function is to perform the logout process. If the logout is successful, the function will return with a `Result` that has a `Void` value, indicating that the operation was successful. If the logout fails, the function will return with a `Result` that has an `Error` value, indicating that the operation failed and providing information about the failure.
    ///
    /// - Parameter credential: A optional dictionary with a `String` key and an `Any` value, which represents the user's credentials for logging out.
    /// - Returns: A `Result` value that indicates the success or failure of the logout operation.
    func logout(credential: [String : Any]? = nil) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            logout(credential: credential, completion: continuation.resume(returning:))
        }
    }
    
    /// Get token.
    ///
    /// The purpose of the function is to retrieve the authentication token. If the authentication token is available and valid, the function will return a `Result` with a value of `AuthToken`. If the authentication token is not available or has expired, the function may delegate the task of refreshing the token to another object, which would be responsible for retrieving a new token.
    ///
    /// - Parameter checkTokenExpiration: A boolean value that indicates whether to check the expiration of the token. If `checkTokenExpiration` is set to `false`, then the function will always call the refresh token.
    /// - Returns: A `Result` value that indicates the success or failure of the operation.
    func getToken(checkTokenExpiration: Bool = true) async -> Result<AuthToken, Error> {
        await withCheckedContinuation { continuation in
            getToken(checkTokenExpiration: checkTokenExpiration, completion: continuation.resume(returning:))
        }
    }
}
