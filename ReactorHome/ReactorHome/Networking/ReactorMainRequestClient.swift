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
    //get hub also gets devices
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
        
        //print(request)
        
        fetch(with: request, decode: {json -> ReactorAPIAlerts? in
            guard let reactorAPIAlerts = json as? ReactorAPIAlerts else { return  nil }
            //print(reactorAPIAlerts.alerts?[0].data)
            return reactorAPIAlerts
        }, completion: completion)
    }
    
    func getEvents(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIEventsResult?, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        
        let preferences = UserDefaults.standard
        
        guard let token = preferences.string(forKey: "access_token") else {
            //do some error handleing here
            return
        }
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetch(with: request, decode: {json -> ReactorAPIEventsResult? in
            guard let reactorAPIEvents = json as? ReactorAPIEventsResult else { return  nil }
            return reactorAPIEvents
        }, completion: completion)
    }
    
    //Device state changes
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
        let postString = "{\"hardware_id\":\"\(hardware_id)\",\"on\":\"\(on)\",\"type\":1}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
    }
    func updateHueLight(from ReactorAPIType: ReactorAPI, hardware_id: String, on: Bool, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
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
        let postString = "{\"hardware_id\":\"\(hardware_id)\",\"on\":\"\(on)\",\"type\":0}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
    }
    
    func updateHueLightBrightness(from ReactorAPIType: ReactorAPI, hardware_id: String, brightness: Int, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
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
        let postString = "{\"hardware_id\":\"\(hardware_id)\",\"brightness\":\"\(brightness)\",\"type\":0}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
    }
    
    //group changes
    func addUserToGroup(from ReactorAPIType: ReactorAPI, userName: String, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postString = "{\"username\":\"\(userName)\"}"
        request.httpBody = postString.data(using: .utf8)
        
        print(request)
        
        fetch(with: request, completion: completion)
    }
    
    func enrollForMobileNotifications(from ReactorAPIType: ReactorAPI, token: String, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let accessToken = preferences.string(forKey: "access_token") else{
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let postString = "{\"notificationAddress\":\"\(token)\"}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
    }
    
    func registerNest(from ReactorAPIType: ReactorAPI, nestPincode: String, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postString = "\(nestPincode)"
        request.httpBody = postString.data(using: .utf8)
        
        print(request)
        print(request.allHTTPHeaderFields)
        print(request.httpBody)
        
        
        fetch(with: request, completion: completion)
        
    }
    
    func registerHueBridge(from ReactorAPIType: ReactorAPI, host: String, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postString = "\(host)"
        request.httpBody = postString.data(using: .utf8)
        
        //        var backToString = String(data:  request.httpBody!, encoding: String.Encoding.utf8) as String?
        //        print(backToString)
        
        print(request)
        print(request.allHTTPHeaderFields)
        print(request.httpBody)
        
        fetch(with: request, completion: completion)
        
    }
    
    func getScheduledEvents(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIScheduledEvents?, APIError>) -> Void) {
        
        
        var request = ReactorAPIType.request
        
        let preferences = UserDefaults.standard
        
        guard let token = preferences.string(forKey: "access_token") else {
            //do some error handleing here
            return
        }
        
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetch(with: request, decode: { json -> ReactorAPIScheduledEvents? in
            guard let reactorAPIScheduledEvents = json as? ReactorAPIScheduledEvents else { return  nil }
            return reactorAPIScheduledEvents
        }, completion: completion)
    }
    
    func newScheduledEvents(from ReactorAPIType: ReactorAPI, deviceType: Int, groupId: Int, deviceId: String, attribute_name: String, attribute_value: String, hour: Int, minute: Int, monday: Bool, tuesday: Bool, wednesday: Bool, thursday: Bool, friday: Bool, saturday: Bool, sunday: Bool,completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        let postString = "{\"deviceType\":\"\(deviceType)\",\"groupId\":\"\(groupId)\",\"deviceId\":\"\(deviceId)\",\"attribute_name\":\"\(attribute_name)\",\"attribute_value\":\"\(attribute_value)\",\"hour\":\"\(hour)\",\"minute\":\"\(minute)\",\"monday\":\"\(monday)\",\"tuesday\":\"\(tuesday)\",\"wednesday\":\"\(wednesday)\",\"thursday\":\"\(thursday)\",\"friday\":\"\(friday)\",\"saturday\":\"\(saturday)\",\"sunday\":\(sunday)}"
        request.httpBody = postString.data(using: .utf8)
        
        print(postString)
        
        fetch(with: request, completion: completion)
    }
    
    func deleteScheduledEvents(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        let preferences = UserDefaults.standard
        guard let token = preferences.string(forKey: "access_token") else{
            //do some error handling here
            print("failed to get access_token from user defaults")
            return
        }
        
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        fetch(with: request, completion: completion)
    }
    
}
