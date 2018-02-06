//
//  Endpoint.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation

protocol Endpoint {
    var base: String { get }
    var path: String { get }
}

//This extends this class
extension Endpoint {
    
    //Sets basic settings for URLSession
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    
    var request: URLRequest {
        let url = urlComponents.url! // builds the URL with the config and reactor enum
        return URLRequest(url: url) //returns a request with the config that was built
    }
}
