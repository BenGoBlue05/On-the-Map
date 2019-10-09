//
//  StudentInformation.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

struct StudentInformation : Codable {
    let firstName: String
    let lastName: String
    let longitude: Double
    let latitude: Double
    let mapString: String
    let mediaURL: String
    let uniqueKey: String
}
