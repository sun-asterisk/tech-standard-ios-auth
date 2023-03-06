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
import RequestBuilder

protocol CredentialAuthGatewayProtocol {
    func login(email: String, password: String) -> AnyPublisher<Token, Error>
    func logout(token: String) -> AnyPublisher<Void, Error>
    func refreshToken(token: String) -> AnyPublisher<Token, Error>
}

final class CredentialAuthGateway: CredentialAuthGatewayProtocol {
    private struct LoginResult: Codable {
        var accessToken: String
        var refreshToken: String
        var tokenType: String
        var expiresAt: Double
        
        enum CodingKeys: String, CodingKey {
            case refreshToken = "refresh_token"
            case accessToken = "access_token"
            case tokenType = "token_type"
            case expiresAt = "expires_at"
        }
        
        func toToken() -> Token {
            Token(
                accessToken: accessToken,
                refreshToken: refreshToken,
                expiredDate: Date(timeIntervalSince1970: expiresAt)
            )
        }
    }
    
    func login(email: String, password: String) -> AnyPublisher<Token, Error> {
        APISessionManager.shared
            .request()
            .method(.post)
            .add(path: Config.URLs.login)
            .add(headers: [
                "accept": "application/json",
                "Content-Type": "application/json",
            ])
            .body(encode: [
                "username": email,
                "password": password
            ])
            .data(type: LoginResult.self)
            .map { $0.toToken() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func logout(token: String) -> AnyPublisher<Void, Error> {
        // Call API in production code
        Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func refreshToken(token: String) -> AnyPublisher<Token, Error> {
        APISessionManager.shared
            .request()
            .method(.post)
            .add(path: Config.URLs.refresh)
            .add(headers: [
                "accept": "application/json",
                "Content-Type": "application/json",
            ])
            .body(encode: [
                "refresh_token": token
            ])
            .data(type: LoginResult.self)
            .map { $0.toToken() }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

extension Container {
    var credentialAuthGateway: Factory<CredentialAuthGatewayProtocol> {
        Factory(self) {
            CredentialAuthGateway()
        }
    }
}
