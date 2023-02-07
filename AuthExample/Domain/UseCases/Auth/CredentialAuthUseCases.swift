//
//  CredentialAuthUseCases.swift
//  AuthExample
//
//  Created by Tuan Truong on 22/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Combine
import CredentialAuth

protocol CredentialAuthUseCases {
    
}

extension CredentialAuthUseCases {
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        CredentialAuth.shared.login(credential: [
            "email": email,
            "password": password
        ])
    }
    
    func logout() -> AnyPublisher<Void, Error> {
        guard let token = CredentialAuth.shared.getToken() else {
            CredentialAuth.shared.resetSignInState()
            
            return Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
            
        }
        
        return CredentialAuth.shared.logout(credential: [
            "token": token.accessToken
        ])
    }
    
    func getToken() -> AnyPublisher<AuthToken, Error> {
        CredentialAuth.shared.getToken(checkTokenExpiration: false)
    }
    
    func getUser() -> User? {
        CredentialAuth.shared.getUser() as? User
    }
}
