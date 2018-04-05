//
//  ReactorClient.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation


class ReactorOauthClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    //in the signature of the function in the success case we define the Class type thats is the generic one in the API
    //recieve the user credentials
    func getOauthToken(from ReactorAPIType: ReactorAPI, username: String, password: String, completion: @escaping (Result<ReactorAPIOauthResult?, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "username=\(username)&password=\(password)&grant_type=password&scope=write&client_id=api-user"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request , decode: { json -> ReactorAPIOauthResult? in
            guard let reactorAPIOauthResult = json as? ReactorAPIOauthResult else { return  nil }
            //print(reactorAPIOauthResult.access_token)
            return reactorAPIOauthResult
        }, completion: completion)
    }
    
    func getOauthRefresh(from ReactorAPIType: ReactorAPI, completion: @escaping (Result<ReactorAPIOauthResult?, APIError>) -> Void) {
        
        let preferences = UserDefaults.standard
        guard let refresh_token = preferences.string(forKey:"refresh_token") else{
            print("refresh_token is nil")
            return
        }
        
        var request = ReactorAPIType.request
        
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        let postString = "refresh_token=\(refresh_token)&grant_type=refresh_token&client_id=api-user"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request , decode: { json -> ReactorAPIOauthResult? in
            guard let reactorAPIOauthResult = json as? ReactorAPIOauthResult else { return  nil }
            return reactorAPIOauthResult
        }, completion: completion)
    }
    
    
}
