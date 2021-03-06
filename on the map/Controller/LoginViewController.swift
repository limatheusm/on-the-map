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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }

    // MARK: Actions
    
    @IBAction func loginPressed(_ sender: Any) {
        errorTextLabel.text = ""
        
        guard let email = emailTextField.text, !email.isEmpty else {
            displayError("Email is requerid")
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            displayError("Password is requerid")
            return
        }
        
        self.setUIEnable(false)
        self.view.endEditing(true)
        LoaderView.show()
        UdacityClient.sharedInstance().authenticate(email: email, password: password) { (success, errorString) in
            DispatchQueue.main.async {
                if success {
                    self.completeLogin()
                } else {
                    self.displayError(errorString)
                }
                LoaderView.hide()
                self.setUIEnable(true)
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        guard let url = URL(string: UdacityClient.Constants.SignUpURL) else { return }
        UIApplication.shared.open(url)
    }
    
    private func completeLogin() {
        errorTextLabel.text = ""
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerNavigationController") as! UINavigationController
        present(controller, animated: true, completion: nil)
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
