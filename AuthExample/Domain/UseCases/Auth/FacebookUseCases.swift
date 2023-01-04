//
//  FacebookUseCases.swift
//  AuthExample
//
//  Created by Tuan Truong on 03/01/2023.
//  Copyright © 2023 Sun Asterisk. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FacebookLogin
import FacebookAuth

protocol FacebookUseCases {

}

extension FacebookUseCases {
    func loginFacebook(viewController: UIViewController?) -> AnyPublisher<(AuthDataResult, [String: Any]?), Error> {
        FacebookAuth.shared.logIn(
            permissions: [.publicProfile, .email],
            fields: "id, name, first_name",
            viewController: viewController
        )
    }
    
    func logoutFacebook() -> Error? {
        FacebookAuth.shared.logout()
    }
    
    func getFacebookUser() -> AnyPublisher<[String: Any]?, Error> {
        FacebookAuth.shared.getUserInfo(fields: "id, name, first_name")
    }
}
