//
//  xHereTests.swift
//  xHereTests
//
//  Created by Developer on 11/7/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import XCTest
import Parse

@testable import xHere

let kUserNameKey = "username"
let kUserNameTestAccount = "TestAccount"

let kUserScreeName = "screenName"
let kUserScreenNameTestAccount = "testAccount"

class xHereTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func testUserObjectNotNil() {
        let expectation = self.expectation(description: "UserObjectNotNil")
        
        let query = PFUser.query()
        query?.whereKey(kUserNameKey, equalTo: kUserNameTestAccount)
        query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            

            if let object = objects?[0], let userObject = object as? User {
                print("UserName = \(userObject.username)")
                expectation.fulfill()
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUserObjectUserName() {
        
        let expectation = self.expectation(description: "UserObjectCorrectUserName")
        
        let query = PFUser.query()
        query?.whereKey(kUserNameKey, equalTo: kUserNameTestAccount)
        query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            
            if let object = objects?[0], let userObject = object as? User {
                
                if userObject.username == kUserNameTestAccount {
                    print("UserName = \(userObject.username)")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    func testUserObjectScreenName() {
        let expectation = self.expectation(description: "UserObjectCorrectScreenName")
        
        let query = PFUser.query()
        query?.whereKey(kUserScreeName, equalTo: kUserScreenNameTestAccount)
        query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            
            if let object = objects?[0], let userObject = object as? User {
                
                if userObject.screenName == kUserScreenNameTestAccount {
                    print("ScreenName = \(userObject.screenName)")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUserObjectFirstLastName() {
        let expectation = self.expectation(description: "UserObjectCorrectFirstLastName")
        
        let query = PFUser.query()
        query?.whereKey(kUserScreeName, equalTo: kUserScreenNameTestAccount)
        query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            
            if let object = objects?[0], let userObject = object as? User {
                
                if userObject.lastName == "testLastName" && userObject.firstName == "testFirstName" {
                    print("LastName = \(userObject.lastName), FirstName = \(userObject.firstName)")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testUserObjectEmail() {
        let expectation = self.expectation(description: "UserObjectCorrectEmail")
        
        let query = PFUser.query()
        query?.whereKey(kUserScreeName, equalTo: kUserScreenNameTestAccount)
        query?.findObjectsInBackground { (objects:[PFObject]?, error:Error?) in
            
            
            if let object = objects?[0], let userObject = object as? User {
                
                if userObject.email == "test@detour.today" {
                    print("Email = \(userObject.email)")
                    expectation.fulfill()
                }
            }
        }
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
