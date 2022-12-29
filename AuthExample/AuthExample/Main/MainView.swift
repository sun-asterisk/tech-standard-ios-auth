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
//import FacebookLogin
//import FacebookCore

struct MainView: View,
                 GetSignInState,
                 GetSignInMethod,
                 CredentialAuthUseCases,
                 GoogleSignInUseCases,
                 FacebookUseCases {
    
    @State private var showLogin = false
    @State private var cancelBag = CancelBag()
    @State private var signInState = SignInState.signedOut
    @State private var signInMethod = SignInMethod.none
    @State private var user: User?
    @State private var googleUser: GIDGoogleUser?
    @State private var facebookUser: [String: Any]?
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
                    
                    Button {
                        isLoading = true
                        loginFacebook()
                    } label: {
                        Text("Facebook")
                            .frame(width: 200)
                    }
                    .contentShape(Rectangle())
                    .buttonStyle(.borderedProminent)
                    
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
        case .facebook:
            faceBookLoginView
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
    
    var faceBookLoginView: some View {
        VStack {
            VStack {
                Text("Welcome")
                    .font(.title)
                
                if let name = facebookUser?["name"] as? String {
                    Text(name)
                        .font(.title2)
                        .minimumScaleFactor(0.1)
                }
            }
            
            .padding(.bottom, 100)
            .padding(.top, 100)
            
            Button {
                logoutFacebook()
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
                restorePreviousGoogleSignIn()
            case .facebook:
                restorePreviousFacebookLogin()
            default:
                break
            }
        } else {
            user = nil
            googleUser = nil
            facebookUser = nil
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
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    isLoading = false
                    self.error = IDError(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { _, user in
                updateGoogleSignInState(with: user)
            })
            .store(in: cancelBag)
    }
    
    func signOutGoogle() {
        let error: Error? = signOutGoogle()
        
        if let error {
            self.error = IDError(error: error)
        }
        
        loadSignInState()
    }
    
    func restorePreviousGoogleSignIn() {
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

// MARK: - Facebook Login
private extension MainView {
    func loginFacebook() {
        loginFacebook(viewController: nil)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    isLoading = false
                    self.error = IDError(error: error)
                case .finished:
                    break
                }
            }, receiveValue: { (result, user) in
                print(result)
                updateFacebookLoginState(with: user)
            })
            .store(in: cancelBag)
    }
    
    func updateFacebookLoginState(with user: [String: Any]?) {
        signInState = .signedIn
        signInMethod = .facebook
        facebookUser = user
        isLoading = false
    }
    
    func logoutFacebook() {
        let error: Error? = logoutFacebook()
        
        if let error {
            self.error = IDError(error: error)
        }
        
        loadSignInState()
    }
    
    func restorePreviousFacebookLogin() {
        getFacebookUser()
            .handleFailure(error: $error)
            .sink { user in
                updateFacebookLoginState(with: user)
            }
            .store(in: cancelBag)
    }
}
