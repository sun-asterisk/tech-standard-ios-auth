import Combine

public extension CredentialAuth {
    /// Call delegate's login method then save returned token.
    /// - Parameter credential: user name or e-mail address, in combination with a password
    /// - Returns: an AnyPublisher containing login results
    func login(credential: [String: Any]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.login(credential: credential, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Logout then clean up saved data.
    /// - Parameter credential: logout information such as device id, token
    /// - Returns: an AnyPublisher containing logout results
    func logout(credential: [String : Any]?) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.logout(credential: credential, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Get token, call refresh token if needs.
    /// - Returns: an AnyPublisher containing token
    func getToken() -> AnyPublisher<AuthToken, Error> {
        Future { [weak self] promise in
            self?.getToken(completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
}
