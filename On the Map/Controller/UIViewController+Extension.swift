//
//  UIViewController+Extension.swift
//  On the Map
//
//  Created by Ben Lewis on 10/10/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func openUrl(_ url: URL){
        let app = UIApplication.shared
        if (app.canOpenURL(url)){
            app.open(url)
        }
    }
    
    func showError(_ message: String, _ title: String = "Error") {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
