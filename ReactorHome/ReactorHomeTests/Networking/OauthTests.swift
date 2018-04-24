//
//  OauthTests.swift
//  ReactorHomeTests
//
//  Created by Reiker Seiffe on 2/21/18.
//  Copyright © 2018 Mock. All rights reserved.
//

import XCTest
@testable import ReactorHome

class OauthTests: XCTestCase {
    
    let client = ReactorOauthClient()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        
        super.tearDown()
    }
    
    func testGoodCredentials(){
        
        client.getOauthToken(from: .oauth, username: "test", password: "test") { result in
            switch result {
            case .success(let reactorAPIResult):
                XCTAssert(reactorAPIResult != nil)
            case .failure(let error):
                print("the error \(error)")
                XCTFail()
            }
        }
    }
    
    func testBadCredentials(){
        
        client.getOauthToken(from: .oauth, username: "asflkjahsdlfkjahsldjf", password: "98qrhweofljkdas") { result in
            switch result {
            case .success(let reactorAPIResult):
                XCTFail()
            case .failure(let error):
                print("the error \(error)")
                XCTAssertTrue(true)
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
