//
//  ReactorMainRequestClient.swift
//  ReactorHome
//
//  Created by Will Mock on 3/17/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

class ReactorMainRequestClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func getGroup(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIGroupResult?, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        print(token)
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        print("header fields")
//        print(request.allHTTPHeaderFields)
        
        fetch(with: request, decode: {json -> ReactorAPIGroupResult? in
            guard let reactorAPIGroupResult = json as? ReactorAPIGroupResult else { return  nil }
            return reactorAPIGroupResult
        }, completion: completion)
        
    }
    
    func getAlerts(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIAlerts?, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        
        let preferences = UserDefaults.standard
        
        guard let token = preferences.string(forKey: "access_token") else {
            //do some error handleing here
            return
        }
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetch(with: request, decode: {json -> ReactorAPIAlerts? in
            guard let reactorAPIAlerts = json as? ReactorAPIAlerts else { return  nil }
            print(reactorAPIAlerts)
            return reactorAPIAlerts
        }, completion: completion)
    }
    
    func getHub(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIHubResult?, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetch(with: request, decode: {json -> ReactorAPIHubResult? in
            guard let reactorAPIHubResult = json as? ReactorAPIHubResult else { return  nil }
            return reactorAPIHubResult
        }, completion: completion)
        
    }
    
    func updateOutlet(from ReactorAPIType: ReactorAPI, hardware_id: String, on: Bool, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postString = "{\"hardware_id\":\"\(hardware_id)\",\"on\":\"\(on)\"}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
        
    }
}
