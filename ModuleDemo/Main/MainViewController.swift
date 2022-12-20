//
//  MainViewController.swift
//  ModuleDemo
//
//  Created by Tuan Truong on 15/12/2022.
//

import UIKit
import GoogleAuth

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(sender: Any) {
        GoogleAuth.shared.login(presentingViewController: self) { result, error in
            if let result {
                print("Signed in, user:", result.user.email ?? "")
            } else if let error {
                print(error)
            }
        }
    }
}
