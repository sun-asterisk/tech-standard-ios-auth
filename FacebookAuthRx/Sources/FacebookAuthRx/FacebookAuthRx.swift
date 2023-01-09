import RxSwift
import FacebookAuth
import FacebookLogin
import FirebaseAuth

public extension FacebookAuth {
    func logIn(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) -> Observable<(AuthDataResult, [String: Any]?)> {
        Observable.create { [weak self] observer in
            self?.logIn(permissions: permissions, fields: fields, viewController: viewController) { result in
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
    
    func getUserInfo(fields: String) -> Observable<[String: Any]?> {
        Observable.create { [weak self] observer in
            self?.getUserInfo(fields: fields) { result in
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
