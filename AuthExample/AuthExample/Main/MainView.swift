//
//  MainView.swift
//  AuthExample
//
//  Created by Tuan Truong on 22/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import SwiftUI
import BaseAuth
import CredentialAuth
import Combine

struct MainView: View, GetSignInState, GetSignInMethod, CredentialAuthUseCases {
    @State private var showLogin = false
    @State private var cancelBag = CancelBag()
    @State private var signInState = SignInState.signedOut
    @State private var signInMethod = SignInMethod.none
    @State private var user: User?
    @State private var error: IDError?
    
    var body: some View {
        content
            .sheet(isPresented: $showLogin) {
                NavigationStack {
                    LoginView {
                        showLogin = false
                        loadSignInState()
                    }
                }
            }
            .alert(error: $error)
            .onAppear {
                loadSignInState()
            }
    }
    
    @ViewBuilder
    var content: some View {
        switch signInState {
        case .signedOut:
            signInMethodsView
        case .signedIn:
            signOutView
        }
    }
    
    @ViewBuilder
    var signInMethodsView: some View {
        VStack {
            Text("Login")
                .font(.title)
                .padding(.bottom, 100)
                .padding(.top, 100)
            
            VStack(spacing: 16) {
                Button {
                    showLogin.toggle()
                } label: {
                    Text("Email/password")
                        .frame(width: 200)
                }
                .contentShape(Rectangle())
                .buttonStyle(.borderedProminent)
                
                Button {
                    
                } label: {
                    Text("Google sign-in")
                        .frame(width: 200)
                }
                .contentShape(Rectangle())
                .buttonStyle(.borderedProminent)
            }
            
            Spacer()
        }
    }
    
    @ViewBuilder
    var signOutView: some View {
        switch getSignInMethod() {
        case .credential:
            credentialView
        case .google:
            Button {
                
            } label: {
                Text("Sign out")
            }
        default:
            EmptyView()
        }
    }
    
    var credentialView: some View {
        VStack {
            VStack {
                Text("Welcome")
                
                if let user {
                    Text(user.email)
                }
            }
            .font(.title)
            .padding(.bottom, 100)
            .padding(.top, 100)
            
            Button {
                logoutCredential()
            } label: {
                Text("Logout")
                    .frame(width: 200)
            }
            .contentShape(Rectangle())
            .buttonStyle(.borderedProminent)
            
            Spacer()
        }
    }
}

// MARK: - Methods
private extension MainView {
    func loadSignInState() {
        signInState = getSignInState()
        signInMethod = getSignInMethod()
        user = getUser()
    }
    
    func logoutCredential() {
        logout()
            .handleFailure(error: $error)
            .sink {
                loadSignInState()
            }
            .store(in: cancelBag)
    }
}
