//
//  ReactorAPIDevice.swift
//  ReactorHome
//
//  Created by Will Mock on 4/4/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIDevice: Decodable {
    let id: String?
    let type: Int?
    let hardware_id: String?
    let connected: Bool?
    let name: String?
    let manufacturer: String?
    let connection_address: String?
    let model: String?
    let on: Bool?
}
