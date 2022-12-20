//
//  MainViewController.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 15/12/2022.
//

import UIKit
import GoogleAuth
import GoogleSignIn

class MainViewController: UIViewController {
    @IBOutlet weak var googleSignInButton: UIView!
    @IBOutlet weak var googleSignOutButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Login state", GoogleAuth.shared.state)

        GoogleAuth.shared.restorePreviousSignIn { [weak self] user, error in
            self?.updateGoogleButtons(with: user)
        }
    }
    
    @IBAction func signIn(sender: Any) {
        GoogleAuth.shared.login(presentingViewController: self) { [weak self] result, user, error in
            if let result {
                print("Signed in, user:", result.user.email ?? "")
            } else if let error {
                print(error)
            }
            
            self?.updateGoogleButtons(with: user)
        }
    }
    
    private func updateGoogleButtons(with user: GIDGoogleUser?) {
        if let user {
            googleSignOutButton.isHidden = false
            googleSignInButton.isHidden = true
            googleSignOutButton.setTitle("Sign out " + (user.profile?.email ?? ""), for: .normal)
        } else {
            googleSignOutButton.isHidden = true
            googleSignInButton.isHidden = false
        }
    }
    
    @IBAction func signOut(sender: Any) {
        GoogleAuth.shared.logout { [weak self] success, error in
            self?.googleSignOutButton.isHidden = success
            self?.googleSignInButton.isHidden = !success
        }
    }
}
