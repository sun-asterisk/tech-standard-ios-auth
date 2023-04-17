//
//  Token+Keychain.swift
//  AuthExample
//
//  Created by Tuan Truong on 17/04/2023.
//  Copyright © 2023 Sun Asterisk. All rights reserved.
//

import Foundation
import KeychainAccess

extension Token {
    static let keychain = Keychain(service: "com.sun-asterisk.AuthExample")
    
    func save(key: String) throws {
        try Token.keychain.set(self, key: key)
    }
    
    static func get(key: String) -> Token? {
        return try? Token.keychain.getObject(key)
    }
    
    static func remove(key: String) throws {
        try Token.keychain.remove(key)
    }
}
