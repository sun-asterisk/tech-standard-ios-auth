import Foundation

/// An enumeration that defines a set of errors that can occur when using the FacebookAuth class.
public enum CredentialAuthError: LocalizedError {
    /// Indicates that there is no access token available for the user.
    case noAccessToken
    
    /// Indicates that there is no saved user.
    case noUser
    
    /// Indicates that there is no biometry.
    case noBiometrics
    
    // LocalAuthentication error (biometrics)
    case localAuthentication(message: String)
    
    public var errorDescription: String? {
        switch self {
        case .noAccessToken:
            return NSLocalizedString("credentialAuth.error.noAccessToken",
                                     value: "No access token available.",
                                     comment: "")
        case .noUser:
            return NSLocalizedString("credentialAuth.error.noUser",
                                     value: "No saved user available.",
                                     comment: "")
        case .noBiometrics:
            return NSLocalizedString("credentialAuth.error.noBiometry",
                                     value: "No biometrics available.",
                                     comment: "")
        case .localAuthentication(let message):
            return message
        }
    }
}
