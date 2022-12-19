//
//  AuthManager+GoogleSignIn.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 16/12/2022.
//

import Foundation
import AuthManager
import GoogleSignIn
import FirebaseCore
import FirebaseAuth

public extension AuthManager {
    
    /// Attempts to restore a previous user sign-in without interaction.
    /// - Parameter completion: invoked when restore completed or failed
    func restorePreviousGoogleSignIn(completion: ((GIDGoogleUser?, Error?) -> Void)? = nil) {
        GIDSignIn.sharedInstance.restorePreviousSignIn(completion: completion)
    }
    
    /// This method should be called from your UIApplicationDelegate’s application:openURL:options: method.
    /// - Parameter url: the url
    /// - Returns: return false if not handled by this app
    func handleGoogleURL(_ url: URL) -> Bool {
        GIDSignIn.sharedInstance.handle(url)
    }
    
    /// Starts an interactive sign-in flow on iOS.
    /// - Parameters:
    ///   - presentingViewController: the presenting view controller
    ///   - completion: invoked when sign in completed or failed
    func signInGoogle(presentingViewController: UIViewController? = nil,
                completion: ((AuthDataResult?, Error?) -> Void)? = nil) {
        
        func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            if let error = error {
                completion?(nil, error)
                return
            }
            
            guard let accessToken = user?.accessToken, let idToken = user?.idToken else {
                completion?(nil, nil)
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { (result, error) in
                completion?(result, error)
            }
        }
        
        if GIDSignIn.sharedInstance.hasPreviousSignIn() {
            GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
                authenticateUser(for: user, with: error)
            }
        } else {
            guard let presentingViewController = presentingViewController
                ?? (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController
            else { return }
            
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
                authenticateUser(for: result?.user, with: error)
            }
        }
    }
    
    /// Signs out the currentUser, removing it from the keychain.
    /// - Parameter completion: invoked when sign out completed or failed
    func signOutGoogle(completion: ((Bool, Error?) -> Void)? = nil) {
        GIDSignIn.sharedInstance.signOut()
        
        do {
            try Auth.auth().signOut()
            completion?(true, nil)
        } catch {
            completion?(false, error)
        }
    }
}
