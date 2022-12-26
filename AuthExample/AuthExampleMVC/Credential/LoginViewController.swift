//
//  LoginViewController.swift
//  AuthExampleMVC
//
//  Created by Tuan Truong on 26/12/2022.
//  Copyright © 2022 Sun Asterisk. All rights reserved.
//

import UIKit

final class LoginViewController: UIViewController, CredentialAuthUseCases {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    var onLogin: ((String, String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
    }
    
    @IBAction private func login(_ sender: Any) {
        messageLabel.text = ""
        
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else {
            messageLabel.text = "Please provide email/password"
            return
        }
        
        onLogin?(email, password)
    }
}
