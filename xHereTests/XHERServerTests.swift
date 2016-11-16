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
                    print(media?.objectId)
                    
                    expectation.fulfill()
                }
                
                
            },
            failure: { (error:Error) in
                
            })
        
        self.waitForExpectations(timeout: 2, handler: nil)
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
