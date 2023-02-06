import FacebookLogin
import FirebaseAuth

public extension FacebookAuth {
    /// Login Facebook and Firebase Authentication.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user and the function is marked as `async`. After the user grants the permissions, the function logs in to Firebase Authentication and retrieves the user's auth data and additional fields and returns them in a `Result` object. The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    /// - Returns: A `Result` object, which contains either an `AuthDataResult` object and a dictionary of the fields returned for the user,  or an error if the login failed.
    func login(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) async -> Result<(AuthDataResult, [String: Any]?), Error> {
        await withCheckedContinuation { continuation in
            login(
                permissions: permissions,
                fields: fields,
                viewController: viewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Login Facebook.
    ///
    /// This function uses the Facebook SDK to initiate the login flow and presents the login dialog to the user and the function is marked as `async`. After the user grants the permissions, the function retrieves the user's fields and returns them in a `Result` object. The function should be called when the user wants to log in to the app using their Facebook account.
    ///
    /// - Parameters:
    ///   - permissions: An array of `Permission` objects that specify the permissions the app is requesting from the user's Facebook account.
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    ///   - viewController: An optional `UIViewController` object that is used to present the Facebook login screen.
    /// - Returns: A `Result` object, where the .success case includes a dictionary of the fields returned for the user, and the .failure case contains an error object describing the failure.
    func login(permissions: [Permission],
               fields: String,
               viewController: UIViewController?) async -> Result<[String: Any]?, Error> {
        await withCheckedContinuation { continuation in
            login(
                permissions: permissions,
                fields: fields,
                viewController: viewController,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Fetches the user's information from Facebook.
    ///
    /// This function uses the Facebook SDK to make a request to the Facebook Graph API to fetch the user's information based on the fields provided and returns the data in a `Result` object and the function is marked as `async`. The function should be called when the user is logged in successfully.
    ///
    /// - Parameters:
    ///   - fields: A comma-separated string of fields to be returned in the response from Facebook's Graph API. ([Reference](https://developers.facebook.com/docs/graph-api/reference/v3.2/user))
    /// - Returns: A `Result` object, where the .success case includes a dictionary of the fields returned for the user, and the .failure case contains an error object describing the failure.
    func getUserInfo(fields: String) async -> Result<[String: Any]?, Error> {
        await withCheckedContinuation { continuation in
            getUserInfo(
                fields: fields,
                completion: continuation.resume(returning:)
            )
        }
    }
    
    /// Link auth provider credentials to an existing user account
    /// - Parameters  credential: An object of AuthCredential type.
    /// - Returns: link results
    func link(with credential: AuthCredential) async -> Result<AuthDataResult?, Error> {
        await withCheckedContinuation { continuation in
            link(
                with: credential,
                completion: continuation.resume(returning:)
            )
        }
    }
}
