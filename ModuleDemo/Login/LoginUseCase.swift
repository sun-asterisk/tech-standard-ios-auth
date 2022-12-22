//
//  LoginUseCase.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 29/11/2022.
//

import Foundation
import CredentialAuth
import Combine

protocol LoginUseCaseProtocol {
    func login(email: String, password: String) -> AnyPublisher<Void, Error>
}

class LoginUseCase: LoginUseCaseProtocol {
    init() {
        
    }
    
    func login(email: String, password: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            CredentialAuth.shared.login(credential: [
                "email": email,
                "password": password
            ]) { result in
                switch result {
                case .success:
                    promise(.success(()))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
