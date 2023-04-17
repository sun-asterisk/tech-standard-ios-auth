//
//  Token+UserDefaults.swift
//  AuthExample
//
//  Created by Tuan Truong on 17/04/2023.
//  Copyright © 2023 Sun Asterisk. All rights reserved.
//

import Foundation

extension Token {
    func save(key: String) throws {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: key)
        }
    }
    
    static func get(key: String) -> Token? {
        guard let data = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? JSONDecoder().decode(Token.self, from: data)
    }
    
    static func remove(key: String) throws {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
