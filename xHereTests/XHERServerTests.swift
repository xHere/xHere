//
//  XHERServerTests.swift
//  xHere
//
//  Created by Developer on 11/15/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import XCTest
import Parse
@testable import xHere

class XHERServerTests: XCTestCase {
    
    let server = XHERServer.sharedInstance
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testDownloadContentByUserCorrectLength() {
        
        let expectation = self.expectation(description: "DownloadUserContentCorrectLength")
        
        let user = PFUser.current() as! User
        
        server.downloadContentBy(
            user: user,
            success: { (contentsArray:[Content]?) in
                
                if let contentsArray = contentsArray {
                    
                    let firstContent = contentsArray[0]
                    print("First Content id = \(firstContent.objectId)")
                    
                    print("Media array count = \(firstContent.mediaArray?.count)")
                    let media = firstContent.mediaArray?[0]
                    print(media!.objectId!)
                    
                    expectation.fulfill()
                }
            },
            failure: { (error:Error?) in
                
            })
        
        self.waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testPostBountyByUser() {
        
        let expectation = self.expectation(description: "PostBountyByUser")
        
        let user = PFUser.current() as! User

        let note = "POSTING 9th BOUNTY!"
        let poi = POI()

        server.postBountyBy(user: user, withNote: note, atPOI: poi, withTokenValue: 11,
            success: {
//                print("POST BOUNTY TEST SUCCESS")
                
                expectation.fulfill()
        },
            failure: {
                print("POST BOUNTY TEST FAILURE")

        })
        
        self.waitForExpectations(timeout: 20, handler: nil)
    }
    
    
//    func testFetchBountyPostedByUser() {
//        
//        let expectation = self.expectation(description: "FetchBountyByUser")
//        
//        let user = PFUser.current() as! User
//        
//        server.fetchBountyPostedBy(user: user,
//           success: { (bountiesArray:[XHERBounty]?) in
//            
//            let numberOfBounties = bountiesArray?.count
//            
//            print("There are \(numberOfBounties)")
//            
//            let fifthBounty = bountiesArray?[4]
//            
//            if fifthBounty?.bountyNote == "POSTING 7th BOUNTY!" {
//                print("Bounty note = \(fifthBounty?.bountyNote)")
//                expectation.fulfill()
//            }
//        },
//           failure: { (error:Error?) in
//            
//        })
//        
//        self.waitForExpectations(timeout: 10, handler: nil)
//    }
    
    
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
