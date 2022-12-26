//
//  MainViewController.swift
//  AuthExampleMVC
//
//  Created by Tuan Truong on 26/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import UIKit
import GoogleAuth
import GoogleSignIn
import BaseAuth

class MainViewController: UIViewController, GetSignInState, GetSignInMethod, CredentialAuthUseCases {
    @IBOutlet weak var loginMethodsView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var googleSignInButton: UIView!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    
    private var signInState = SignInState.signedOut
    private var signInMethod = SignInMethod.none
    private var user: User?
    private var googleUser: GIDGoogleUser?
    private var cancelBag = CancelBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSignInState()
    }
    
    @IBAction func googleSignIn(sender: Any) {
        GoogleAuth.shared.signIn(presentingViewController: self) { [weak self] _ in
            self?.loadSignInState()
        }
    }
    
    @IBAction func logout(sender: Any) {
        switch signInMethod {
        case .credential:
            logoutCredential()
        case .google:
            signOutGoogle()
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showCredentialLogin",
           let loginViewController = segue.destination as? LoginViewController {
            loginViewController.onLogin = { [weak self] email, password in
                self?.loginCredential(email: email, password: password)
                self?.dismiss(animated: true)
            }
        }
    }
}

// MARK: - Methods
private extension MainViewController {
    func loadSignInState() {
        signInState = getSignInState()
        signInMethod = getSignInMethod()
        
        // Get user
        if signInState == .signedIn {
            logoutView.isHidden = false
            loginMethodsView.isHidden = true
            
            switch signInMethod {
            case .credential:
                user = getUser()
                emailLabel.text = user?.email ?? ""
            case .google:
                restorePreviousSignInGoogle()
            default:
                break
            }
        } else {
            logoutView.isHidden = true
            loginMethodsView.isHidden = false
            emailLabel.text = ""
            
            user = nil
            googleUser = nil
        }
    }
}

// MARK: - CredentialAuth
private extension MainViewController {
    func loginCredential(email: String, password: String) {
        login(email: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.loadSignInState()
            }
            .store(in: cancelBag)
    }
    
    func logoutCredential() {
        logout()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print(error)
                default:
                    break
                }
            } receiveValue: { [weak self] in
                self?.loadSignInState()
            }
            .store(in: cancelBag)
    }
}

// MARK: - GoogleAuth
private extension MainViewController {
    func signOutGoogle() {
        GoogleAuth.shared.signOut { [weak self] _ in
            self?.loadSignInState()
        }
    }
    
    func restorePreviousSignInGoogle() {
        GoogleAuth.shared.restorePreviousSignIn { [weak self] result in
            switch result {
            case .success(let user):
                self?.emailLabel.text = user.profile?.email
            case .failure:
                self?.emailLabel.text = ""
                break
            }
        }
    }
}
