import Combine
import FacebookLogin
import FirebaseAuth

public extension FacebookAuth {
    func logIn(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) -> AnyPublisher<(AuthDataResult, [String: Any]?), Error> {
        Future { [weak self] promise in
            self?.logIn(permissions: permissions, fields: fields, viewController: viewController, completion: promise)
        }
        .eraseToAnyPublisher()
    }
    
    func getUserInfo(fields: String) -> AnyPublisher<[String: Any]?, Error> {
        Future { [weak self] promise in
            self?.getUserInfo(fields: fields, completion: promise)
        }
        .eraseToAnyPublisher()
    }
}
