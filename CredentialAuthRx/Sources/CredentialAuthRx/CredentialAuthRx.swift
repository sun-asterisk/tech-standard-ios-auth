import CredentialAuth
import RxSwift

public extension CredentialAuth {
    /// Login using the provided credentials.
    ///
    /// The purpose of the function is to initiate a login process using the provided credential information. The credential parameter is a dictionary that contains the necessary information for the login process, such as a username and password.
    ///
    /// - Parameter credential: A dictionary with a `String` key and an `Any` value, which represents the user's credentials for authentication.
    /// - Returns: An `Observable` object, which emits value that indicates the success or failure of the login operation.
    func login(credential: [String: Any]) -> Observable<Void> {
        Observable.create { [weak self] observer in
            self?.login(credential: credential) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    func loginWithBiometrics(reason: String) -> Observable<Void> {
        Observable.create { [weak self] observer in
            self?.loginWithBiometrics(reason: reason) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
 
    /// Logout.
    ///
    /// The purpose of the function is to perform the logout process. If the logout is successful, the function will return with a `Result` that has a `Void` value, indicating that the operation was successful. If the logout fails, the function will return with a `Result` that has an `Error` value, indicating that the operation failed and providing information about the failure.
    ///
    /// - Parameter credential: A optional dictionary with a `String` key and an `Any` value, which represents the user's credentials for logging out.
    /// - Returns: An `Observable` object, which emits value that indicates the success or failure of the logout operation.
    func logout(credential: [String : Any]? = nil) -> Observable<Void> {
        Observable.create { [weak self] observer in
            self?.logout(credential: credential) { result in
                switch result {
                case .success:
                    observer.onNext(())
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// Get token.
    ///
    /// The purpose of the function is to retrieve the authentication token for the current user. The function returns an `Observable` value that represents the authentication token as a stream of events. If the authentication token is not available or has expired, the function may delegate the task of refreshing the token to another object, which would be responsible for retrieving a new token.
    ///
    /// - Parameter checkTokenExpiration: A boolean value that indicates whether to check the expiration of the token. If `checkTokenExpiration` is set to `false`, then the function will always call the refresh token.
    /// - Returns: An `Observable` object, which emits value that indicates the success or failure of the operation.
    func getToken(checkTokenExpiration: Bool = true) -> Observable<AuthToken> {
        Observable.create { [weak self] observer in
            self?.getToken(checkTokenExpiration: checkTokenExpiration) { result in
                switch result {
                case .success(let token):
                    observer.onNext(token)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
}
