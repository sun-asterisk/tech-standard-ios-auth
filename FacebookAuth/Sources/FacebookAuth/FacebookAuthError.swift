//
//  File.swift
//  
//
//  Created by Tuan Truong on 04/01/2023.
//

import Foundation

public enum FacebookAuthError: LocalizedError {
    case cancelled
    case noAccount
    case noAccessToken
    case notLogin
    
    public var errorDescription: String? {
        switch self {
        case .cancelled:
            return NSLocalizedString("facebookAuth.error.cancelled",
                                     value: "User cancelled login.",
                                     comment: "")
        case .noAccount:
            return NSLocalizedString("facebookAuth.error.noAccount",
                                     value: "No account.",
                                     comment: "")
        case .noAccessToken:
            return NSLocalizedString("facebookAuth.error.noAccessToken",
                                     value: "No access token.",
                                     comment: "")
        case .notLogin:
            return NSLocalizedString("facebookAuth.error.notLogin",
                                     value: "Not login.",
                                     comment: "")
        }
    }
}
