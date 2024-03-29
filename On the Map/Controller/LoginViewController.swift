//
//  ViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/8/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTf: UITextField!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        guard let username = emailTf.text else { return }
        guard let pw = passwordTf.text else { return }
        setLoggingIn(true)
        OTMClient.shared.login(username, pw){res in
            self.setLoggingIn(false)
            switch res {
            case .success(let creds):
                OTMSession.shared.accountId = creds.account.key
                OTMSession.shared.sessionId = creds.session.id
                self.performSegue(withIdentifier: "tabSegue", sender: nil)
                break
            case .error(let errorMessage):
                self.showError(errorMessage, "Login Failed")
            }
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool){
        if loggingIn {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        emailTf.isEnabled = !loggingIn
        passwordTf.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

