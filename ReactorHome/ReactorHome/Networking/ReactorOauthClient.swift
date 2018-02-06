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
            return reactorAPIOauthResult
        }, completion: completion)
    }
    
    
    
}
