import Foundation

/// Base auth class.
open class BaseAuth {
    // MARK: - Public properties
    public var state: SignInState {
        didSet {
            saveState(state)
        }
    }
    
    public static var state: SignInState {
        SignInState(rawValue: UserDefaults.standard.integer(forKey: BaseAuth.stateKey)) ?? .signedOut
    }
    
    public var method: SignInMethod {
        didSet {
            saveMethod(method)
        }
    }
    
    public static var method: SignInMethod {
        SignInMethod(rawValue: UserDefaults.standard.integer(forKey: BaseAuth.methodKey)) ?? .none
    }
    
    // MARK: - Private properties
    private static let stateKey = "AUTH_STATE_KEY"
    private static let methodKey = "AUTH_METHOD_KEY"
    
    public init() {
        let defaults = UserDefaults.standard
        state = SignInState(rawValue: defaults.integer(forKey: BaseAuth.stateKey)) ?? .signedOut
        method = SignInMethod(rawValue: defaults.integer(forKey: BaseAuth.methodKey)) ?? .none
    }
    
    /// Reset to default values.
    open func reset() {
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
