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
        let res = MKPointAnnotation()
        res.coordinate = CLLocationCoordinate2D(latitude: info.latitude, longitude: info.longitude)
        res.title = "\(info.firstName) \(info.lastName)"
        res.subtitle = info.mediaURL
        return res
    }
}
