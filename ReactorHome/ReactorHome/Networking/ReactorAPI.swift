//
//  ReactorAPI.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation

//These will change the URl string that is created in Endpoint
enum ReactorAPI {
    case oauth
    case register
}

//This extention to API will add functionality and conform to Enpoint
//This means it needs the base string and path string
extension ReactorAPI: Endpoint {
    
    //The base string for the reactor api
    //For another class the base string could be
    var base: String {
        return "https://api.myreactorhome.com"
    }
    
    //This checks to see what case of the enum is selected and finishes building the URL from it
    var path: String { //Computed property  for the path, this is why these are cool as hell
        switch self {
        case .oauth: return "/user/oauth/token"
        case .register: return "/user/api/users/register"

        }
    }
}
