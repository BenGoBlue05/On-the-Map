//
//  AddLocationViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/10/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstNameTf: UITextField!
    
    @IBOutlet weak var lastNameTf: UITextField!
    
    @IBOutlet weak var locationTf: UITextField!
    
    @IBOutlet weak var mediaUrlTf: UITextField!
    
    @IBOutlet weak var addLocationBtn: UIButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func confirmLocation(_ info: StudentInformation, _ mapItem: MKMapItem) {
        let vc = storyboard?.instantiateViewController(identifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
        vc.studentInfo = info
        vc.mapItem = mapItem
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func findLocation(_ sender: Any) {
        checkComplete()
        setLoading(true)
        let fn = firstNameTf.text!
        let ln = lastNameTf.text!
        let url = mediaUrlTf.text!
        let loc = locationTf.text!
        OTMClient.shared.getLocation(loc){ result in
            self.setLoading(false)
            switch result {
            case .error(let message):
                self.showError(message)
            case .success(let mapItem):
                let coord = mapItem.placemark.coordinate
                let lon = coord.longitude
                let lat = coord.latitude
                let key = OTMSession.shared.accountId
                let info = StudentInformation(firstName: fn, lastName: ln, longitude: lon, latitude: lat, mapString: loc, mediaURL: url, uniqueKey: key)
                self.confirmLocation(info, mapItem)
            }
        }
    }
    
    func checkComplete(){
        if firstNameTf.text?.count ?? 0 == 0 {
            showError("Enter first name")
        } else if lastNameTf.text?.count ?? 0 == 0 {
            showError("Enter last name")
        } else if locationTf.text?.count ?? 0 == 0 {
            showError("Enter location")
        } else if mediaUrlTf.text?.count ?? 0 == 0 {
            showError("Enter media URL")
        }
    }
    
    @IBAction func onCancelClicked(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func setLoading(_ isLoading: Bool) {
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        firstNameTf.isEnabled = !isLoading
        lastNameTf.isEnabled = !isLoading
        locationTf.isEnabled = !isLoading
        mediaUrlTf.isEnabled = !isLoading
        addLocationBtn.isEnabled = !isLoading
        cancelBtn.isEnabled = !isLoading
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}
