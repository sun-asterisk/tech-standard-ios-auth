//
//  AuthError.swift
//  AuthManager
//
//  Created by Tuan Truong on 20/12/2022.
//

import Foundation

public enum AuthError: LocalizedError {
    case noToken
    
    public var errorDescription: String? {
        switch self {
        case .noToken:
            return "No token"
        }
    }
}
