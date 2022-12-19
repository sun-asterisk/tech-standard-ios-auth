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
        AuthManager.shared.delegate = self
        FirebaseApp.configure()
        
//        FirebaseApp.app()?.options.clientID
        
        AuthManager.shared.restorePreviousGoogleSignIn { user, error in
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
        
        handled = AuthManager.shared.handleGoogleURL(url)
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

extension AppDelegate: AuthManagerDelegate {
    func login(completion: @escaping (AppToken) -> Void, failure: @escaping (Error) -> Void) {
        guard let loginInfo = AuthManager.shared.loginInfo as? (String, String) else { return }
        
        let (email, password) = loginInfo
        
        API.shared.login(email: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    failure(error)
                }
            } receiveValue: { token in
                completion(token)
            }
            .store(in: &bag)
    }
    
    func refreshToken(token: String, completion: (AppToken) -> Void, failure: (Error) -> Void) {
        
    }
}
