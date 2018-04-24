//
//  ReactorAPIScheduledEvents.swift
//  ReactorHome
//
//  Created by Will Mock on 4/18/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIScheduledEvents: Decodable {
    let events: [ReactorAPIScheduleEvent]?
}
