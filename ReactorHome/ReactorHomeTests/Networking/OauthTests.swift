//
//  OauthTests.swift
//  ReactorHomeTests
//
//  Created by Reiker Seiffe on 2/6/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import XCTest
@testable import ReactorHome

class OauthTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testPass() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let client = ReactorOauthClient()
        
        let password = "test"
        let username = "test2"
        
        client.getOauthToken(from: .oauth, username: username, password: password) { result in
            switch result {
            case .success(let reactorAPIResult):
                guard let oauthResults = reactorAPIResult else {
                    print("There was an error")
                    return
                }
                
                XCTAssert(oauthResults.token_type == "Bearer")
                
            case .failure(let error):
                
                XCTFail()
                print("the error \(error)")
            }
        }
        
    }
    
    func testBadUsername(){
        let client = ReactorOauthClient()
        
        let password = "jkfalhjfasjvna;jsn;va;slidn;ioanef"
        let username = "test2"
        
        client.getOauthToken(from: .oauth, username: username, password: password) { result in
            switch result {
            case .success(let reactorAPIResult):
                guard let oauthResults = reactorAPIResult else {
                    print("There was an error")
                    return
                }
                
                XCTFail()
                
            case .failure(let error):
                XCTAssert(1 == 1)
                print("the error \(error)")
            }
        }
    }
    

}
