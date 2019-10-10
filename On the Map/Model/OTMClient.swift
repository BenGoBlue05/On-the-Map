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
        case addLocation = "StudentLocation"
        var url: URL {
            return URL(string: "\(Endpoints.base)/\(rawValue)")!
        }
    }
    
    func getRequest<T: Decodable>(_ url: URL, _ completion: @escaping (OTMResult<T>) -> Void) {
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            self.handleResponse(data, error, completion)
        }
        task.resume()
    }
    
    func postRequest<B : Encodable, R: Decodable>(_ url: URL, _ body: B, _ completion: @escaping (OTMResult<R>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            self.handleResponse(data, error, completion)
        }
        task.resume()
    }
    
    func handleResponse<T: Decodable>(_ data: Data?, _ error: Error? ,_ completion: @escaping (OTMResult<T>) -> Void) {
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
    
    func login(_ username: String, _ password: String, _ completion: @escaping (OTMResult<LoginResponse>) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: LoginCredentials(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let subData = data.subdata(in: 5..<data.count)
                self.handleResponse(subData, error, completion)
            } else {
                self.handleResponse(data, error, completion)
            }
        }
        task.resume()
    }
    
    func logOut(_ completion: @escaping (OTMResult<LogOutResponse>) -> Void){
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        for cookie in HTTPCookieStorage.shared.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if let data = data {
              let subData = data.subdata(in: 5..<data.count)
              self.handleResponse(subData, error, completion)
          } else {
              self.handleResponse(data, error, completion)
          }
        }
        task.resume()
    }
    
    func getStudentLocations(_ completion: @escaping (OTMResult<StudentLocationResponse>) -> Void){
        getRequest(Endpoints.studentLocations.url, completion)
    }
    
    func addStudentLocation(_ info: StudentInformation, _ completion: @escaping (OTMResult<AddLocationResponse>) -> Void) {
        postRequest(Endpoints.addLocation.url, info, completion)
    }

}
