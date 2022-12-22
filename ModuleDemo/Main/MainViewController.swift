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
        
        googleSignOutButton.isHidden = true
        
        GoogleAuth.shared.restorePreviousSignIn { [weak self] result in
            switch result {
            case .success(let user):
                self?.updateGoogleButtons(with: user)
            case .failure:
                self?.updateGoogleButtons(with: nil)
            }
        }
    }
    
    @IBAction func signIn(sender: Any) {
        GoogleAuth.shared.signIn(presentingViewController: self) { [weak self] result in
            switch result {
            case .success(let (authResult, user)):
                print("Signed in, user:", authResult?.user.email ?? "")
                self?.updateGoogleButtons(with: user)
            case .failure:
                self?.updateGoogleButtons(with: nil)
            }
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
        GoogleAuth.shared.signOut { [weak self] result in
            switch result {
            case .success:
                self?.googleSignOutButton.isHidden = true
                self?.googleSignInButton.isHidden = false
            case .failure:
                self?.googleSignOutButton.isHidden = false
                self?.googleSignInButton.isHidden = true
            }
        }
    }
}
