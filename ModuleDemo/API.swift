//
//  API.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 05/12/2022.
//

import Foundation
import AuthManager
import Combine

class API {
    static let shared = API()
    
    func login(email: String, password: String) -> AnyPublisher<AppToken, Error> {
        Just(AppToken(accessToken: "accessToken", refreshToken: "refreshToken", expiredDate: Date()))
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

struct AppToken: AuthToken {
    var accessToken: String
    var refreshToken: String
    var expiredDate: Date
}

struct User: AuthUser {
    
}
