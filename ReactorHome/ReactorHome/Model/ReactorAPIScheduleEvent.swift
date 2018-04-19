//
//  ReactorAPIScheduleEvent.swift
//  ReactorHome
//
//  Created by Will Mock on 4/18/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIScheduleEvent: Decodable {
    let id: Int?
    let deviceType: String?
    let groupId: Int?
    let deviceId: String?
    let attribute_name: String?
    let attribute_value: String?
    let minute: Int?
    let hour: Int?
    let monday: Bool?
    let tuesday: Bool?
    let wednesday: Bool?
    let thursday: Bool?
    let friday: Bool?
    let saturday: Bool?
    let sunday: Bool?
    let deviceName: String?
}
