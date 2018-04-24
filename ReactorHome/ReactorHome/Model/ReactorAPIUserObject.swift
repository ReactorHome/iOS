//
//  ReactorAPIUserObject.swift
//  ReactorHome
//
//  Created by Will Mock on 3/17/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIUserObject: Decodable {
    let id: Int?
    let username: String?
    let email: String?
    let firstName: String?
    let lastName: String?
    let ownerGroupId: Int?
    let groupsList: [Int]?
}
