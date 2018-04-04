//
//  ReactorAPIHubResult.swift
//  ReactorHome
//
//  Created by Will Mock on 4/4/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation
struct ReactorAPIHubResult: Decodable {
    let id: String?
    let group_id: Int?
    let devices: [ReactorAPIDevice]?
    let hardware_id: String?
    let connected: Bool?
}
