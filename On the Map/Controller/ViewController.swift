//
//  ViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/8/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
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
            case .success:
                self.performSegue(withIdentifier: "tabSegue", sender: nil)
                break
            case .error(let errorMessage):
                self.showLoginFailed(errorMessage)
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
    
    func showLoginFailed(_ message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}

