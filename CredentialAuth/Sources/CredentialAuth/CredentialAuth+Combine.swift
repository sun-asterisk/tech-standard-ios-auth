import Combine

public extension CredentialAuth {
    /// Login using the provided credentials.
    ///
    /// The purpose of the function is to initiate a login process using the provided credential information. The credential parameter is a dictionary that contains the necessary information for the login process, such as a username and password.
    /// 
    /// - Parameter credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for authentication.
    /// - Returns: An `AnyPublisher` object, which emits value that indicates the success or failure of the login operation.
    func login(credential: [String: Any]) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.login(credential: credential, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Authenticate a user using biometrics.
    /// - Parameter reason: A string parameter that describes the reason for the biometric authentication request.
    /// - Returns: An `AnyPublisher` object, which emits value that indicates the success or failure of the operation.
    func authenticateWithBiometrics(reason: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.authenticateWithBiometrics(reason: reason, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Logs a user in using biometrics.
    /// - Parameter reason: A string parameter that describes the reason for the biometric authentication request.
    /// - Returns: An `AnyPublisher` object, which emits value that indicates the success or failure of the operation.
    func loginWithBiometrics(reason: String) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.loginWithBiometrics(reason: reason, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Logout.
    ///
    /// The purpose of the function is to perform the logout process. If the logout is successful, the function will return with a `Result` that has a `Void` value, indicating that the operation was successful. If the logout fails, the function will return with a `Result` that has an `Error` value, indicating that the operation failed and providing information about the failure.
    /// 
    /// - Parameter credential: A optional dictionary with a `String` key and an `Any` value, which represents the user's credentials for logging out.
    /// - Returns: An `AnyPublisher` object, which emits value that indicates the success or failure of the logout operation.
    func logout(credential: [String : Any]? = nil) -> AnyPublisher<Void, Error> {
        Future { [weak self] promise in
            self?.logout(credential: credential, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    /// Get token.
    ///
    /// The purpose of the function is to retrieve the authentication token for the current user. The function returns an `AnyPublisher` value that represents the authentication token as a stream of events. If the authentication token is not available or has expired, the function may delegate the task of refreshing the token to another object, which would be responsible for retrieving a new token.
    ///
    /// - Parameter checkTokenExpiration: A boolean value that indicates whether to check the expiration of the token. If `checkTokenExpiration` is set to `false`, then the function will always call the refresh token.
    /// - Returns: An `AnyPublisher` object, which emits value that indicates the success or failure of the operation.
    func getToken(checkTokenExpiration: Bool = true) -> AnyPublisher<AuthToken, Error> {
        Future { [weak self] promise in
            self?.getToken(checkTokenExpiration: checkTokenExpiration, completion: promise)
        }
        .eraseToAnyPublisher()
    }
}
