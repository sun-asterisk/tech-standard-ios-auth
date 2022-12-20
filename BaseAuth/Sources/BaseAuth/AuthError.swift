import Foundation

/// Auth errors.
public enum AuthError: LocalizedError {
    /// No token found.
    case noToken
    
    public var errorDescription: String? {
        switch self {
        case .noToken:
            return "No token"
        }
    }
}
