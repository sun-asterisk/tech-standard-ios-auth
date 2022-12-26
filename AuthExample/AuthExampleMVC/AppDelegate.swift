//
//  AppDelegate.swift
//  AuthExampleMVC
//
//  Created by Tuan Truong on 26/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import UIKit
import CredentialAuth
import FirebaseCore
import Combine
import Factory

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    let credentialAuthGateway = Container.credentialAuthGateway.callAsFunction()
    private var cancelBag = CancelBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Credential login
        CredentialAuth.shared.delegate = self
        
        FirebaseApp.configure()
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
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

