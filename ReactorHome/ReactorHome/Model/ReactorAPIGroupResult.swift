//
//  ReactorAPIGroupResult.swift
//  ReactorHome
//
//  Created by Will Mock on 3/17/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIGroupResult: Decodable {
    //let results: [ReactorOauth]? //results
    let groups: [ReactorAPIGroupObject]?
}
