//
//  ViewController.swift
//  on the map
//
//  Created by Matheus Lima on 30/12/18.
//  Copyright © 2018 Matheus Lima. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorTextLabel: UILabel!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorTextLabel.text = ""
    }

    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let url = URL(string: "https://udacity.com") else { return }
        UIApplication.shared.open(url)
    }
    
    private func completeLogin() {
        errorTextLabel.text = ""
    }
}

// MARK: - LoginViewController (Configure UI)

private extension LoginViewController {
    
    func setUIEnable(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        loginButton.alpha = enabled ? 1 : 0.5
        signUpButton.isEnabled = enabled
        signUpButton.alpha = enabled ? 1 : 0.5
    }
    
    func displayError(_ errorString: String?) {
        guard let errorString = errorString else { return }
        errorTextLabel.text = errorString
    }
}
