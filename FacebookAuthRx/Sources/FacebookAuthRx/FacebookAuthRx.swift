import RxSwift
import FacebookAuth
import FacebookLogin
import FirebaseAuth

public extension FacebookAuth {
    /// Login Facebook and Firebase Authentication.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user. After the user grants the permissions, the function logs in to Firebase Authentication and retrieves the user's auth data and additional fields and returns them in an `Observable` object. The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    /// - Returns: An `Observable` object, which contains either an `AuthDataResult` object and a dictionary of the fields returned for the user,  or an error if the login failed.
    func login(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) -> Observable<(AuthDataResult, [String: Any]?)> {
        Observable.create { [weak self] observer in
            self?.login(permissions: permissions, fields: fields, viewController: viewController) { result in
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
    
    /// Login Facebook.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user. After the user grants the permissions, the function retrieves the user's fields and returns them in an `Observable` object.  The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    /// - Returns: An `Observable` object, which emits a dictionary of the fields returned for the user,  or an error if the login failed.
    func login(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) -> Observable<[String: Any]?> {
        Observable.create { [weak self] observer in
            self?.login(permissions: permissions, fields: fields, viewController: viewController) { result in
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
    
    /// Fetches the user's information from Facebook.
    ///
    /// This function uses the Facebook SDK to make a request to the Facebook Graph API to fetch the user's information based on the fields provided and returns the data in an `Observable` object. The function should be called when the user is logged in successfully.
    ///
    /// - Parameters:
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    /// - Returns: An `Observable` object, which emits a dictionary of the fields returned for the user,  or an error if the login failed.
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
