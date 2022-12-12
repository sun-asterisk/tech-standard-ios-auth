//
//  LoginUseCase.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 29/11/2022.
//

import Foundation
import AuthManager
import Combine

protocol LoginUseCaseProtocol {
    func login(email: String, password: String) -> AnyPublisher<Void, Error>
}

class LoginUseCase: LoginUseCaseProtocol {
    init() {
        
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        AuthManager.shared.loginInfo = (email, password)
        
        return Future { promise in
            AuthManager.shared.login {
                promise(.success(()))
            } failure: { error in
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
}
