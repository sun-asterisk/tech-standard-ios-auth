import CredentialAuth
import RxSwift

public extension CredentialAuth {
    /// Call delegate's login method then save returned token.
    /// - Parameter credential: user name or e-mail address, in combination with a password
    /// - Returns: an Observable containing login results
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
    
    /// Logout then clean up saved data.
    /// - Parameter credential: logout information such as device id, token
    /// - Returns: an Observable containing logout results
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
    
    /// Get token, call refresh token if needs.
    /// - Returns: an Observable containing token
    func getToken() -> Observable<AuthToken> {
        Observable.create { [weak self] observer in
            self?.getToken { result in
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
