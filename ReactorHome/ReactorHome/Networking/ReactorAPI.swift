//
//  ReactorAPI.swift
//  Reactor - Networking
//
//  Created by Reiker Seiffe on 2/5/18.
//  Copyright © 2018 ReikerSeiffe.com. All rights reserved.
//

import Foundation

//These will change the URl string that is created in Endpoint
enum ReactorAPI {
    //Registration
    case oauth
    case register
    case registerHub
    case registerWithNest(String) //pass in mongoHubId
    case registerHueBridge(String) //pass in mongoHubId
    //Info retrival
    case getHubInfo(String) //pass in mongoHubId
    case getGroupInfo(String) //pass in groupNumber
    case getUsersGroups
    case getAlertsForGroup(String) //pass in groupNumber
    case getEventsForGroup(String) //pass in groupNumber
    case getScheduledEventsforGroup(String)//pass in groupNumber
    case newScheduledEvent
    case deleteScheduledEvent(String)
    case enrollForMobileNotifications
    //Change Device state
    case updateNestThermostat(String, String) //pass in mongoHubId and thermostatId
    case updateOutlet(String)//pass in mongoHubId
    case updateHueLight(String)//pass in mongoHubId
    //Settings
    case addUserToGroup(String)//pass in groupNumber
}

//This extention to API will add functionality and conform to Enpoint
//This means it needs the base string and path string
extension ReactorAPI: Endpoint {
    
    //The base string for the reactor api
    //For another class the base string could be
    var base: String {
        return "https://api.myreactorhome.com"
    }
    
    //This checks to see what case of the enum is selected and finishes building the URL from it
    var path: String { //Computed property  for the path, this is why these are cool as hell
        switch self {
        case .oauth: return "/user/oauth/token"
        case .register: return "/user/api/users/register"
        case .registerHub: return "/"
        case .registerWithNest(let hubId): return "/device/api/\(hubId)/thermostat/register/nest/"
        case .registerHueBridge(let hubId): return "/device/api/\(hubId)/bridge/"
        case .getHubInfo(let hubId): return "/device/api/\(hubId)/hub"
        case .getGroupInfo(let groupNumber): return "/user/api/groups/\(groupNumber)"
        case .getUsersGroups: return "/user/api/users/me/groups"
        case .getAlertsForGroup(let groupNumber): return "/user/api/alerts/\(groupNumber)/"
        case .getEventsForGroup(let groupNumber): return "/user/api/events/\(groupNumber)/"
        case .getScheduledEventsforGroup(let groupNumber): return "/user/api/cloud/schedule/group/\(groupNumber)/"
        case .newScheduledEvent: return "/user/api/cloud/schedule/new/"
        case .deleteScheduledEvent(let scheduleEventId): return "/user/api/cloud/schedule/delete/\(scheduleEventId)/"
        case .enrollForMobileNotifications: return "/user/api/notifications/enroll/"
        case .updateNestThermostat(let hubId, let thermostatId): return "/device/api/\(hubId)/thermostat/\(thermostatId)"
        case .updateOutlet(let hubId): return "/device/api/\(hubId)/outlet/"
        case .updateHueLight(let hubId): return "/device/api/\(hubId)/light/"
        case .addUserToGroup(let groupNumber): return "/user/api/groups/\(groupNumber)/users/"
        }
    }
}
