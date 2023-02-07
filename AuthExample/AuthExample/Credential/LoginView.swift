//
//  LoginView.swift
//  AuthExample
//
//  Created by Tuan Truong on 23/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import SwiftUI
import ValidatedPropertyKit

struct LoginView: View, CredentialAuthUseCases {
    @Environment(\.dismiss) var dismiss
    
    var loginSuccess: () -> Void
    
    // State
    @Validated(!.isEmpty)
    private var email = ""
    
    @Validated(.range(8...))
    private var password = ""
    
    @FocusState private var focusedField: Field?
    @State private var didTapLogin = false
    @State private var cancelBag = CancelBag()
    @State private var error: IDError?
    
    private enum Field: Hashable {
        case email
    }
    
    var body: some View {
        Form {
            Section(footer: validationView) {
                TextField("Email", text: $email)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                    .focused($focusedField, equals: .email)
                    .task {
                        try? await Task.sleep(nanoseconds: 600_000_000)  // 0.5s
                        focusedField = .email
                    }
                
                SecureField("Password", text: $password)
            }
            
            Section {
                if didTapLogin {
                    loginButton
                        .validated(
                            self._email,
                            self._password
                        )
                } else {
                    loginButton
                }
            }
            
            Section {
                Button("Test data") {
                    email = "user1234"
                    password = "passwordRequired@123"
//                    email = "testuser02"
//                    password = "testuser02"
                }
                
                Button("Reset form") {
                    email = ""
                    password = ""
                    didTapLogin = false
                }
                .foregroundColor(.red)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
        .alert(error: $error)
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder
    private var validationView: some View {
        if didTapLogin {
            VStack(alignment: .leading) {
                if !_email.isValid {
                    Text("Invalid email")
                }
                
                if !_password.isValid {
                    Text("Invalid password")
                }
            }
        } else {
            EmptyView()
        }
    }
    
    private var loginButton: some View {
        Button {
            didTapLogin = true
            
            if _email.isValid && _password.isValid {
                login(email: email, password: password)
            }
        } label: {
            Text("Login")
        }
    }
}

// MARK: - Methods
extension LoginView {
    func login(email: String, password: String) {
        login(email: email, password: password)
            .handleFailure(error: $error)
            .sink {
                loginSuccess()
            }
            .store(in: cancelBag)
    }
}
