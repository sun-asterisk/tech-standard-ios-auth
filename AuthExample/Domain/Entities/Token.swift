//
//  Token.swift
//  AuthExample
//
//  Created by Tuan Truong on 22/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import Foundation
import CredentialAuth

struct Token: AuthToken, Codable {
    var accessToken = ""
    var refreshToken = ""
    var expiredDate = Date()
}

extension Token {
    static let stub = Token(
        accessToken: UUID().uuidString,
        refreshToken: UUID().uuidString,
        expiredDate: Date(timeIntervalSinceNow: 3600)
    )
}
