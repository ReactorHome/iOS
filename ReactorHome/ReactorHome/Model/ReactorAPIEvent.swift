//
//  ReactorAPIEvent.swift
//  ReactorHome
//
//  Created by Will Mock on 4/8/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

struct ReactorAPIEvent: Decodable {
    let id: Int?
    let occurredAt: Double?
    var occurredAtDate: String?{
        if let occurEpoch = occurredAt {
            let date = Date(timeIntervalSince1970: (occurEpoch/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }else{
            return nil
        }
    }
    var occurredAtDateLong: String?{
        if let occurEpoch = occurredAt {
            let date = Date(timeIntervalSince1970: (occurEpoch/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            return strDate
        }else{
            return nil
        }
    }
    let device: String?
    let json: ReactorAPIEventJSON?

}
