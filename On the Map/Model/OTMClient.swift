//
//  Client.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation

class OTMClient {
    
    static let shared = OTMClient()
    
    static let genericError = "An error occurred"
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        case login
        
        
        var stringValue: String {
            switch  self {
            case .login:
                return "\(Endpoints.base)/session"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    func login(_ username: String, _ password: String, _ completion: @escaping (OTMResult<Bool>) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let errorDescription = error?.localizedDescription ?? OTMClient.genericError
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(OTMResult.error(errorDescription))
                }
                return
            }
            let subData = data.subdata(in: 5..<data.count)
            let decoder = JSONDecoder()
            do {
                let creds = try decoder.decode(LoginResponse.self, from: subData)
                OTMSession.shared.accountId = creds.account.key
                OTMSession.shared.sessionId = creds.session.id
                DispatchQueue.main.async {
                    completion(OTMResult.success(true))
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OTMErrorResponse.self, from: subData)
                    DispatchQueue.main.async {
                        completion(OTMResult.error(errorResponse.error ?? errorDescription))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(OTMResult.error(errorDescription))
                    }
                }
            }
        }
        task.resume()
    }
}
