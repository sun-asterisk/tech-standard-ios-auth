//
//  BaseAuth.swift
//  AuthManager
//
//  Created by Tuan Truong on 20/12/2022.
//

import Foundation

public class BaseAuth {
    public var state = SignInState.signedOut
    
    /// Logout then clean up saved data.
    /// - Parameters:
    ///   - credential: logout information such as device id, token
    ///   - completion: invoked when logout completed
    func logout(credential: [String: Any]?, completion: ((Bool, Error?) -> Void)? = nil) {
        
    }
    
    func cleanUp() {
        
    }
}
