//
//  ReactorAPIAlert.swift
//  ReactorHome
//
//  Created by Will Mock on 4/8/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIAlert: Decodable {
    let id: Int?
    let types: Int?
    let data: String?
    let dataJson: String?
    let filename: String?
}
