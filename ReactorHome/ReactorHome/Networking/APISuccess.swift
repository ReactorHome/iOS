//
//  APISuccess.swift
//  ReactorHome
//
//  Created by Will Mock on 2/9/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

enum APISuccess: APIResponse, Error {
    case registeredUser
    case addedUserToGroup
    var localizedDescription: String {
        switch self {
        case .registeredUser: return "Successfully Registered User"
        case .addedUserToGroup: return "Successfully Added User To Group"
        }
    }
}
