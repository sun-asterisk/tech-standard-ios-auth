//
//  File.swift
//  
//
//  Created by Tuan Truong on 04/01/2023.
//

import Foundation

/// An enumeration that defines a set of errors that can occur when using the FacebookAuth class.
public enum FacebookAuthError: LocalizedError {
    /// Indicates that the user cancelled the login request.
    case cancelled
    
    /// Indicates that there is no access token available for the user.
    case noAccessToken
    
    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return NSLocalizedString("facebookAuth.error.cancelled",
                                     value: "User cancelled login.",
                                     comment: "")
        case .noAccessToken:
            return NSLocalizedString("facebookAuth.error.noAccessToken",
                                     value: "No access token available.",
                                     comment: "")
        }
    }
}
