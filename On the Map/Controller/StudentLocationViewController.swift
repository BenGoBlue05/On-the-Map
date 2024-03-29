//
//  StudentLocationViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OTMClient.shared.getStudentLocations { result in
            switch result{
            case .error(let message):
                self.showError(message)
            case .success(let response):
                OTMSession.shared.setStudentLocations(response.results)
                self.mapView.addAnnotations(OTMSession.shared.pointAnnotations)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
                openUrl(URL(string: toOpen)!)
            }
        }
    }
    
    
    @IBAction func onLogOutClicked(_ sender: Any) {
        OTMClient.shared.logOut { _ in
            OTMSession.shared.clearSession()
            self.tabBarController?.navigationController?.popViewController(animated: true)
        }
    }
}
