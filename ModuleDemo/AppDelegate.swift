//
//  AppDelegate.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 25/11/2022.
//

import UIKit
import Combine
import FirebaseCore
import GoogleAuth
import CredentialAuth

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var bag = Set<AnyCancellable>()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CredentialAuth.shared.delegate = self
        
        FirebaseApp.configure()
        
        return true
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool

        handled = GoogleAuth.shared.handle(url)
        
        if handled {
            return true
        }
        
        return false
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

extension AppDelegate: CredentialAuthDelegate {
    func login(credential: [String : Any],
               success: @escaping (AppToken, User?) -> Void,
               failure: @escaping (Error) -> Void) {
        
        guard let email = credential["email"] as? String,
              let password = credential["password"] as? String
        else { return }
        
        API.shared.login(email: email, password: password)
            .sink { loginCompletion in
                switch loginCompletion {
                case .finished:
                    break
                case .failure(let error):
                    failure(error)
                }
            } receiveValue: { token in
                success(token, nil)
            }
            .store(in: &bag)
    }
    
    func logout(credential: [String : Any]?, success: (() -> Void)?, failure: ((Error) -> Void)?) {
        
    }
    
    func refreshToken(token: String, success: @escaping (T) -> Void, failure: @escaping (Error) -> Void) {
        
    }
}
