//
//  OTMSession.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation
import MapKit

class OTMSession {
    
    static let shared = OTMSession()
    
    var sessionId  = ""
    var accountId = ""
    var studentLocations = [StudentInformation]()
    var pointAnnotations = [MKPointAnnotation]()
    
    func setStudentLocations(_ info: [StudentInformation]) {
        studentLocations = info
        pointAnnotations = info.map(self.createMKAnnotation(_:))
    }
    
    func createMKAnnotation(_ info: StudentInformation) -> MKPointAnnotation {
        let lat = CLLocationDegrees(info.latitude)
        let lon = CLLocationDegrees(info.longitude)
        let res = MKPointAnnotation()
        res.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        res.title = "\(info.firstName) \(info.lastName)"
        res.subtitle = info.mediaURL
        return res
    }
}
