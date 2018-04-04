//
//  ReactorAPIGroupObject.swift
//  ReactorHome
//
//  Created by Will Mock on 3/17/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIGroupObject: Decodable {
    //let results: [ReactorOauth]? //results
    let id: Int?
    let owner: ReactorAPIUserObject?
    let accountList: [ReactorAPIUserObject]?
    let hubId: String?
    let name: String?
}
