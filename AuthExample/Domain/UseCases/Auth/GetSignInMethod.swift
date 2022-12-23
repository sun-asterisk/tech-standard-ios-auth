//
//  GetSignInMethod.swift
//  AuthExample
//
//  Created by Tuan Truong on 23/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Foundation
import BaseAuth

protocol GetSignInMethod {
    
}

extension GetSignInMethod {
    func getSignInMethod() -> SignInMethod {
        BaseAuth.method
    }
}
