import FacebookLogin
import FirebaseAuth

public extension FacebookAuth {
    func logIn(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) async -> Result<(AuthDataResult, [String: Any]?), Error> {
        await withCheckedContinuation { continuation in
            logIn(
                permissions: permissions,
                fields: fields,
                viewController: viewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    func getUserInfo(fields: String) async -> Result<[String: Any]?, Error> {
        await withCheckedContinuation { continuation in
            getUserInfo(
                fields: fields,
                completion: continuation.resume(returning:)
            )
        }
    }
}
