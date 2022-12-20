/// Base auth class.
open class BaseAuth {
    public var state = SignInState.signedOut
    
    public init() {
        
    }
    
    /// Logout then clean up saved data.
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    open func logout(credential: [String: Any]?, completion: ((Bool, Error?) -> Void)? = nil) {
        
    }
    
    /// Clean up saved data.
    open func cleanUp() {
        
    }
}
