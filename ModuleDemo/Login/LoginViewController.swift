//
//  LoginViewController.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 29/11/2022.
//

import UIKit
import Combine

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    
    private let loginUseCase = LoginUseCase()
    private var bag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageLabel.text = ""
    }
    
    @IBAction private func login(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty
        else { return }
        
        messageLabel.text = ""
        
        loginUseCase.login(email: email, password: password)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] in
                self?.messageLabel.text = "Login success"
            }
            .store(in: &bag)
    }
}
