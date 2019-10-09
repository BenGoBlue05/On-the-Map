//
//  LoginResponse.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

struct LoginResponse : Codable {
    let account: UdacityAccount
    let session: LoginSession
}

struct UdacityAccount: Codable {
    let registered: Bool
    let key: String
}

struct  LoginSession: Codable {
    let id: String
}
