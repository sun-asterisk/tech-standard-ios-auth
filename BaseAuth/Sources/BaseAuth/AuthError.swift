import Foundation

/// Auth errors.
public enum AuthError: LocalizedError {
    /// No token found.
    case noToken
    
    // Not signed in Firebase Auth
    case notSignedInFirebaseAuth
    
    public var errorDescription: String? {
        switch self {
        case .noToken:
            return NSLocalizedString("baseAuth.error.noToken",
                                     value: "No token found.",
                                     comment: "")
        case .notSignedInFirebaseAuth:
            return NSLocalizedString("baseAuth.error.notSignedInFirebaseAuth",
                                     value: "Not signed in Firebase Auth.",
                                     comment: "")
        }
    }
}
