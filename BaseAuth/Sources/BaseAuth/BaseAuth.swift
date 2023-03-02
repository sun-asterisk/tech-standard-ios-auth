import Foundation

/// Base auth class.
open class BaseAuth: NSObject {
    // MARK: - Public properties
    
    /// Get/set sign-in state.
    open var state: SignInState {
        didSet {
            saveState(state)
        }
    }
    
    /// Get sign-in state.
    public static var state: SignInState {
        SignInState(rawValue: UserDefaults.standard.integer(forKey: BaseAuth.stateKey)) ?? .signedOut
    }
    
    /// Get/set sign-in method.
    public var method: SignInMethod {
        didSet {
            saveMethod(method)
        }
    }
    
    /// Get sign-in method.
    public static var method: SignInMethod {
        SignInMethod(rawValue: UserDefaults.standard.integer(forKey: BaseAuth.methodKey)) ?? .none
    }
    
    // MARK: - Private properties
    private static let stateKey = "AUTH_STATE_KEY"
    private static let methodKey = "AUTH_METHOD_KEY"
    
    public override init() {
        let defaults = UserDefaults.standard
        state = SignInState(rawValue: defaults.integer(forKey: BaseAuth.stateKey)) ?? .signedOut
        method = SignInMethod(rawValue: defaults.integer(forKey: BaseAuth.methodKey)) ?? .none
        super.init()
    }
    
    /// Set sign-in state.
    open func setSignInState() {
        fatalError()
    }
    
    /// Reset sign-in state.
    open func resetSignInState() {
        state = .signedOut
        method = .none
    }
    
    /// Clean up saved data.
    open func cleanUp() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: BaseAuth.stateKey)
        defaults.removeObject(forKey: BaseAuth.methodKey)
    }
}

// MARK: - Private methods
private extension BaseAuth {
    func saveState(_ state: SignInState) {
        UserDefaults.standard.setValue(state.rawValue, forKey: BaseAuth.stateKey)
    }
    
    func saveMethod(_ method: SignInMethod) {
        UserDefaults.standard.setValue(method.rawValue, forKey: BaseAuth.methodKey)
    }
}
