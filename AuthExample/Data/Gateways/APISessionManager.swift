//
//  APISessionManager.swift
//  AuthExample
//
//  Created by Tuan Truong on 30/01/2023.
//  Copyright © 2023 Sun Asterisk. All rights reserved.
//

import Foundation
import RequestBuilder

struct APISessionManager {
    static let shared: BaseSessionManager = {
        let base = URL(string: Config.URLs.base)
        let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
        
        return BaseSessionManager(base: base, session: session)
            .set(decoder: JSONDecoder())
            .set(encoder: JSONEncoder())
    }()
}
