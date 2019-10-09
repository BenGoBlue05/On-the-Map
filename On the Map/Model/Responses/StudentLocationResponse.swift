//
//  StudentLocationResponse.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

struct StudentLocationResponse: Codable {
    let results: [StudentInformation]
}
