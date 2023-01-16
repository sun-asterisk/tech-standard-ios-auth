import RxSwift
import GoogleAuth
import GoogleSignIn
import FirebaseAuth

public extension GoogleAuth {
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Returns: an Observable containing the signed-in user
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
    
    /// Sign-in Google and Firebase Auth.
    /// - Parameter presentingViewController: the presenting view controller
    /// - Returns: an Observable containing sign-in results
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
    
    /// Sign-in Google.
    /// - Parameter presentingViewController: the presenting view controller
    /// - Returns: an Observable containing sign-in results
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
}
