//
//  ReactorRegisterUserClient.swift
//  ReactorHome
//
//  Created by Will Mock on 2/9/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation


class ReactorRegisterUserClient: APIClient {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func registerNewUser(from ReactorAPIType: ReactorAPI, username: String, email: String, firstName: String, lastName: String, password: String, completion: @escaping (Result<APISuccess, APIError>) -> Void) {
        
        var request = ReactorAPIType.request
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let postString = "{\"username\":\"\(username)\",\"email\":\"\(email)\",\"password\":\"\(password)\",\"firstName\":\"\(firstName)\",\"lastName\":\"\(lastName)\"}"
        request.httpBody = postString.data(using: .utf8)
        
        fetch(with: request, completion: completion)
    }
}
