import RxSwift
import GoogleAuth
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Restores the previous sign-in session, if it exists.
    /// - Returns: An observable emitting the user info if successful, or an error if the sign-in failed.
    func restorePreviousSignIn() -> Observable<GIDGoogleUser> {
        Observable.create { [weak self] observer in
            self?.restorePreviousSignIn { result in
                switch result {
                case .success(let user):
                    observer.onNext(user)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// Signs the user in with Google and Firebase Auth, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: An observable emitting the `AuthDataResult` and user info if successful, or an error if the sign-in failed.
    func signIn(presentingViewController: UIViewController? = nil) -> Observable<(AuthDataResult?, GIDGoogleUser?)> {
        Observable.create { [weak self, weak presentingViewController] observer in
            self?.signIn(presentingViewController: presentingViewController) { result in
                switch result {
                case .success(let resultAndUser):
                    observer.onNext(resultAndUser)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// Signs the user in with Google, presenting a sign-in view controller if necessary.
    /// - Parameter presentingViewController: The view controller to present the sign-in view controller from.
    /// - Returns: An observable emitting the `AuthDataResult` if successful, or an error if the sign-in failed.
    func signIn(presentingViewController: UIViewController? = nil) -> Observable<GIDGoogleUser?> {
        Observable.create { [weak self, weak presentingViewController] observer in
            self?.signIn(presentingViewController: presentingViewController) { result in
                switch result {
                case .success(let user):
                    observer.onNext(user)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    /// Link auth provider credentials to an existing user account.
    /// - Parameters  credential: An object of AuthCredential type.
    /// - Returns: An observable emitting the `AuthDataResult` if successful, or an error if the linking failed.
    func link(with credential: AuthCredential) -> Observable<AuthDataResult?> {
        Observable.create { [weak self] observer in
            self?.link(with: credential, completion: { result in
                switch result {
                case .success(let result):
                    observer.onNext(result)
                    observer.onCompleted()
                case .failure(let error):
                    observer.onError(error)
                }
            })
            
            return Disposables.create()
        }
    }
}
