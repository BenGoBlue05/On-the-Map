//
//  Client.swift
//  On the Map
//
//  Created by Ben Lewis on 10/9/19.
//  Copyright © 2019 Ben Lewis. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class OTMClient {
    
    static let shared = OTMClient()
    
    static let genericError = "An error occurred"
    
    enum Endpoints: String {
        static let base = "https://onthemap-api.udacity.com/v1"
        case login = "session"
        case studentLocations = "StudentLocation?limit=100&order=-updatedAt"
        
        var url: URL {
            return URL(string: "\(Endpoints.base)/\(rawValue)")!
        }
    }
    
    func getRequest<T: Decodable>(_ url: URL, _ completion: @escaping (OTMResult<T>) -> Void) {
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            self.handleResponse(data, response, error, completion)
        }
        task.resume()
    }
    
    func postRequest<B : Encodable, R: Decodable>(_ url: URL, body: B, _ completion: @escaping (OTMResult<R>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            self.handleResponse(data, response, error, completion)
        }
        task.resume()
    }
    
    func handleResponse<T: Decodable>(_ data: Data?, _ response: URLResponse?, _ error: Error? ,_ completion: @escaping (OTMResult<T>) -> Void) {
        let errorDescription = error?.localizedDescription ?? OTMClient.genericError
        var result: OTMResult<T>!
        if let data = data {
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(T.self, from: data)
                result = OTMResult.success(responseObject)
            } catch {
                let errorResponse = try? decoder.decode(OTMErrorResponse.self, from: data)
                result = OTMResult.error(errorResponse?.error ?? errorDescription)
            }
        } else {
            result = OTMResult.error(errorDescription)
        }
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    func getLocation(_ location: String, _ completion: @escaping (OTMResult<MKMapItem>) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = location
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let item = response?.mapItems.first {
                completion(OTMResult.success(item))
            } else {
                completion(OTMResult.error(error?.localizedDescription ?? OTMClient.genericError))
            }
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
    
    func getStudentLocations(_ completion: @escaping (OTMResult<StudentLocationResponse>) -> Void){
        getRequest(Endpoints.studentLocations.url, completion)
    }

}
