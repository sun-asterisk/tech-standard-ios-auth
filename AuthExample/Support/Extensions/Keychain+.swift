//
//  Keychain+.swift
//  AuthExample
//
//  Created by Tuan Truong on 17/04/2023.
//  Copyright © 2023 Sun Asterisk. All rights reserved.
//

import Foundation
import KeychainAccess

extension Keychain {
    public func getObject<T: Decodable>(_ key: String) throws -> T? {
        guard let data = try getData(key) else {
                return nil
        }
        let object = try JSONDecoder().decode(T.self, from: data)
        return object
    }

    public func set<T: Encodable>(_ value: T, key: String) throws {
        let data = try JSONEncoder().encode(value)
        try set(data, key: key)
    }
}
