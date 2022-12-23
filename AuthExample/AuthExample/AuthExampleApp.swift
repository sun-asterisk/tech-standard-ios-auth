//
//  AuthExampleApp.swift
//  AuthExample
//
//  Created by Tuan Truong on 22/12/2022.
//

import SwiftUI

@main
struct AuthExampleApp: App {
    @UIApplicationDelegateAdaptor var delegate: AppDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
