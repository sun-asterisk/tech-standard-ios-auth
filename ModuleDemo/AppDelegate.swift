//
//  AppDelegate.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 25/11/2022.
//

import UIKit
import AuthManager
import Combine
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var bag = Set<AnyCancellable>()
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        CredentialAuth.shared.delegate = self
        FirebaseApp.configure()
        
//        FirebaseApp.app()?.options.clientID
        
        CredentialAuth.shared.restorePreviousGoogleSignIn { user, error in
            if error != nil || user == nil {
                // Show the app's signed-out state.
                print(error)
            } else {
                // Show the app's signed-in state.
            }
        }
        
        return true
    }
    
    func application(
      _ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        var handled: Bool
        
        handled = CredentialAuth.shared.handleGoogleURL(url)
        if handled {
            return true
        }

        // Handle other custom URL types.
        
        // If not handled by this app, return false.
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
    func login(credential: [String: Any]?, completion: @escaping (AppToken?, User?, Error?) -> Void) {
        guard let credential,
              let email = credential["email"] as? String,
              let password = credential["password"] as? String
        else { return }
        
        API.shared.login(email: email, password: password)
            .sink { loginCompletion in
                switch loginCompletion {
                case .finished:
                    break
                case .failure(let error):
                    completion(nil, nil, error)
                }
            } receiveValue: { token in
                completion(token, nil, nil)
            }
            .store(in: &bag)
    }
    
    func refreshToken(token: String, completion: @escaping (AppToken?, Error?) -> Void) {
        
    }
    
    func logout(credential: [String : Any]?, completion: @escaping (Bool, Error?) -> Void) {
        
    }
}
