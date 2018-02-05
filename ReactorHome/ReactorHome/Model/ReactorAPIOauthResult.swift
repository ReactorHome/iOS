//
//  ReactorAPIResult.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation


///the JSON has a key called results and its an array of ReactorOauth tokens.

struct ReactorAPIOauthResult: Decodable {
    //let results: [ReactorOauth]? //results
    
    let access_token: String?
    let token_type: String?
    let refresh_token: String?
    let expires_in: Int?
    let scope: String?
    
}
