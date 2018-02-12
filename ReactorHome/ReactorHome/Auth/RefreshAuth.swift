//
//  RefreshAuth.swift
//  ReactorHome
//
//  Created by Will Mock on 2/12/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import Foundation

func oauthValidationCheck() -> Bool {
    
    let preferences = UserDefaults.standard
    let client = ReactorOauthClient()
    var successFlag = false
    let currentDateTime = Date()
    
    //checking to make sure we have an expires_at set in user prefs
    guard let expires_at = preferences.object(forKey: "expires_at") as? Date else{
        print("No Expiration set in user defaults. Something went wrong in refreshAuth / oauthVaildationCheck()")
        successFlag = false
        return successFlag
    }
    
    //if still valid we do not need to refresh
    if ( expires_at >= currentDateTime){
        successFlag = true
        return successFlag
        
    }else{
        //this could still be broken
        //refreshing here
        client.getOauthRefresh(from: .oauth){ result in
            switch result {
            case .success(let reactorAPIResult):
                guard let oauthResults = reactorAPIResult else {
                    print("There was an error in oauthValidationCheck request portion")
                    successFlag = false
                    return
                }
                //setting access_token
                preferences.set(oauthResults.access_token, forKey: "access_token")
                
                //setting expires_at
                let currentDateTime = Date()
                let expires_in = TimeInterval(oauthResults.expires_in!)
                let expires_at = currentDateTime.addingTimeInterval(expires_in)
                preferences.set(expires_at, forKey: "expires_at")
                
                //setting refresh_token
                preferences.set(oauthResults.refresh_token, forKey: "refresh_token")
                
                successFlag = true
                
            case .failure(let error):
                print("the error \(error)")
                successFlag = false
                return
            }
        }
        return successFlag
    }
}
