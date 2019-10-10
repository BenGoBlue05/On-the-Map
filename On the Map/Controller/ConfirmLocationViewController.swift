//
//  ConfirmLocationViewController.swift
//  On the Map
//
//  Created by Ben Lewis on 10/10/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: UIViewController, MKMapViewDelegate {

    var studentInfo: StudentInformation!
    
    var mapItem: MKMapItem!
    
    @IBOutlet weak var locMapView: MKMapView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var finishBtn: UIButton!
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = mapItem.placemark.coordinate
        let boundaryDist = 1000.0
        locMapView.region = MKCoordinateRegion(center: center, latitudinalMeters: boundaryDist, longitudinalMeters: boundaryDist)
        let annotation = createMKAnnotation(mapItem, studentInfo)
        locMapView.addAnnotation(annotation)
        locMapView.selectAnnotation(annotation, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func createMKAnnotation(_ item: MKMapItem, _ studentInfo: StudentInformation) -> MKPointAnnotation {
        let res = MKPointAnnotation()
        res.coordinate = item.placemark.coordinate
        res.title = studentInfo.mapString
        return res
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        OTMClient.shared.addStudentLocation(studentInfo){ result in
            switch result {
            case .error(let message):
                self.showError(message)
            case .success:
                self.navigationController?.popToRootViewController(animated: false)
            }
        }
    }
    
    func setLoading(_ isLoading: Bool){
        if isLoading {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        finishBtn.isEnabled = !isLoading
    }
}
