import Foundation

public extension CredentialAuth {
    /// Call delegate's login method then save returned token.
    /// - Parameter credential: user name or e-mail address, in combination with a password
    /// - Returns: login results
    func login(credential: [String: Any]) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            login(credential: credential, completion: continuation.resume(returning:))
        }
    }
    
    /// Logout then clean up saved data.
    /// - Parameter credential: logout information such as device id, token
    /// - Returns: logout results
    func logout(credential: [String : Any]? = nil) async -> Result<Void, Error> {
        await withCheckedContinuation { continuation in
            logout(credential: credential, completion: continuation.resume(returning:))
        }
    }
    
    /// Get token, call refresh token if needs.
    /// - Returns: getting token results
    func getToken() async -> Result<AuthToken, Error> {
        await withCheckedContinuation { continuation in
            getToken(completion: continuation.resume(returning:))
        }
    }
}
