//
//  AppDelegate.swift
//  AuthExample
//
//  Created by Tuan Truong on 23/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Foundation
import UIKit
import CredentialAuth
import Factory
import FirebaseCore

final class AppDelegate: NSObject, UIApplicationDelegate {
    var cancelBag = CancelBag()
    let credentialAuthGateway = Container.credentialAuthGateway.callAsFunction()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Credential
        CredentialAuth.shared.delegate = self
        
        // Google Sign-in
        FirebaseApp.configure()
        
        return true
    }
}

// MARK: - CredentialAuthDelegate
extension AppDelegate: CredentialAuthDelegate {
    func login(credential: [String : Any],
               success: @escaping (Token, User?) -> Void,
               failure: @escaping (Error) -> Void) {
        guard let email = credential["email"] as? String,
              let password = credential["password"] as? String
        else { return }
        
        credentialAuthGateway.login(email: email, password: password)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    failure(error)
                default:
                    break
                }
            } receiveValue: { token, user in
                success(token, user)
            }
            .store(in: cancelBag)
    }
    
    func logout(credential: [String : Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        guard let token = credential?["token"] as? String else { return }
        
        credentialAuthGateway.logout(token: token)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    failure?(error)
                default:
                    break
                }
            } receiveValue: {
                success?()
            }
            .store(in: cancelBag)
    }
    
    func refreshToken(token: String, success: @escaping (Token) -> Void, failure: @escaping (Error) -> Void) {
        credentialAuthGateway.refreshToken(token: token)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    failure(error)
                default:
                    break
                }
            } receiveValue: { token in
                success(token)
            }
            .store(in: cancelBag)
    }
}

