//
//  GoogleSignInUseCases.swift
//  AuthExample
//
//  Created by Tuan Truong on 26/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Foundation
import GoogleSignIn
import FirebaseAuth
import GoogleAuth
import Combine

protocol GoogleSignInUseCases {
    
}

extension GoogleSignInUseCases {
    func restorePreviousSignInGoogle() -> AnyPublisher<GIDGoogleUser, Error> {
        GoogleAuth.shared.restorePreviousSignIn()
    }
    
    func signInGoogle(presentingViewController: UIViewController? = nil)
        -> AnyPublisher<(AuthDataResult?, GIDGoogleUser?), Error> {
        GoogleAuth.shared.signIn(presentingViewController: presentingViewController)
    }
    
    func signOutGoogle() -> AnyPublisher<Void, Error> {
        GoogleAuth.shared.signOut()
    }
}
