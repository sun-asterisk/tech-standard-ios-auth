//
//  CredentialAuthGateway.swift
//  AuthExample
//
//  Created by Tuan Truong on 22/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Combine
import CredentialAuth
import Foundation
import Factory

protocol CredentialAuthGatewayProtocol {
    func login(email: String, password: String) -> AnyPublisher<(Token, User), Error>
    func logout(token: String) -> AnyPublisher<Void, Error>
    func refreshToken(token: String) -> AnyPublisher<Token, Error>
}

final class CredentialAuthGateway: CredentialAuthGatewayProtocol {
    func login(email: String, password: String) -> AnyPublisher<(Token, User), Error> {
        // Call API in production code
        Just((Token.mock(), User(email: email)))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func logout(token: String) -> AnyPublisher<Void, Error> {
        // Call API in production code
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func refreshToken(token: String) -> AnyPublisher<Token, Error> {
        // Call API in production code
        Just(Token.mock())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

extension Container {
    static let credentialAuthGateway = Factory(scope: .singleton) {
        CredentialAuthGateway() as CredentialAuthGatewayProtocol
    }
}
