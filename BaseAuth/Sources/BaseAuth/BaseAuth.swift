import Foundation

/// Base auth class.
open class BaseAuth {
    public var state: SignInState {
        didSet {
            saveState(state)
        }
    }
    
    private let stateKey = "STATE_KEY"
    
    public init() {
        self.state = SignInState(rawValue:  UserDefaults.standard.integer(forKey: stateKey)) ?? .signedOut
    }
    
    /// Clean up saved data.
    open func cleanUp() {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: stateKey)
    }
}

private extension BaseAuth {
    func saveState(_ state: SignInState) {
        UserDefaults.standard.setValue(state.rawValue, forKey: stateKey)
    }
}
