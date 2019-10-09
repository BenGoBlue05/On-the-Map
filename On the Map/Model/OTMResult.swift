//
//  OTMResult.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

enum OTMResult<T> {
    case success(T)
    case error(String)
}
