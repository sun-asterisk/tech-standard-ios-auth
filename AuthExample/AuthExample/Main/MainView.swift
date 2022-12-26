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
import GoogleSignInSwift
import GoogleSignIn

struct MainView: View, GetSignInState, GetSignInMethod, CredentialAuthUseCases, GoogleSignInUseCases {
    @State private var showLogin = false
    @State private var cancelBag = CancelBag()
    @State private var signInState = SignInState.signedOut
    @State private var signInMethod = SignInMethod.none
    @State private var user: User?
    @State private var googleUser: GIDGoogleUser?
    @State private var error: IDError?
    @State private var isLoading = false
    
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
        ZStack {
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
                    
                    GoogleSignInButton {
                        isLoading = true
                        signInGoogle()
                    }
                    .frame(width: 220)
                }
                .disabled(isLoading)
                
                Spacer()
            }
            
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding(30)
                    .background(.thinMaterial)
                    .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder
    var signOutView: some View {
        switch signInMethod {
        case .credential:
            credentialView
        case .google:
            googleSignInView
        default:
            EmptyView()
        }
    }
    
    var credentialView: some View {
        VStack {
            VStack {
                Text("Welcome")
                    .font(.title)
                
                if let user {
                    Text(user.email)
                        .font(.title2)
                        .minimumScaleFactor(0.1)
                }
            }
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
    
    var googleSignInView: some View {
        VStack {
            VStack {
                Text("Welcome")
                    .font(.title)
                
                if let email = googleUser?.profile?.email {
                    Text(email)
                        .font(.title2)
                        .minimumScaleFactor(0.1)
                }
            }
            
            .padding(.bottom, 100)
            .padding(.top, 100)
            
            Button {
                signOutGoogle()
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
        
        // Get user
        if signInState == .signedIn {
            switch signInMethod {
            case .credential:
                user = getUser()
            case .google:
                restorePreviousSignIn()
            default:
                break
            }
        } else {
            user = nil
            googleUser = nil
        }
    }
}

// MARK: - Credential login
private extension MainView {
    func logoutCredential() {
        logout()
            .handleFailure(error: $error)
            .sink {
                loadSignInState()
            }
            .store(in: cancelBag)
    }
}

// MARK: - Google Sign-in
private extension MainView {
    func signInGoogle() {
        signInGoogle(presentingViewController: nil)
            .handleFailure(error: $error)
            .sink(receiveCompletion: { _ in
                isLoading = false
            }, receiveValue: { _, user in
                updateGoogleSignInState(with: user)
            })
            .store(in: cancelBag)
    }
    
    func signOutGoogle() {
        signOutGoogle()
            .handleFailure(error: $error)
            .sink {
                loadSignInState()
            }
            .store(in: cancelBag)
    }
    
    func restorePreviousSignIn() {
        restorePreviousSignInGoogle()
            .handleFailure(error: $error)
            .sink { user in
                updateGoogleSignInState(with: user)
            }
            .store(in: cancelBag)
    }
    
    func updateGoogleSignInState(with user: GIDGoogleUser?) {
        signInState = .signedIn
        signInMethod = .google
        googleUser = user
        isLoading = false
    }
        
}
