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
    let poiServer = XHEREGooglePlacesServer.sharedInstance
    
    
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
    
    func testDownloadPOIAndBounty() {
        
        let expectation = self.expectation(description: "DownloadPOIAndBounty")
        
        let query = PFQuery(className: kPFClassPOI)
        query.findObjectsInBackground { (poiArray:[PFObject]?, error:Error?) in
            
            let firstPOI = poiArray?[0] as! POI
            
            let bountyQuery = PFQuery(className: kPFClassBounty)
            bountyQuery.whereKey(kPFKeyPOI, equalTo: firstPOI)
            bountyQuery.findObjectsInBackground(block: { (bountyArray:[PFObject]?, error:Error?) in
                
                for bounty in bountyArray! {
                    let bounty = bounty as! XHERBounty
                    print("Bounty Note = \(bounty.bountyNote)")
                    print("POI name\(bounty.postedAtLocation.placeName)")
                }
                expectation.fulfill()
            })
            
        }
        
        self.waitForExpectations(timeout: 20, handler: nil)
    }
    
    
    func testPostBountyByUser() {
        
        let expectation = self.expectation(description: "PostBountyByUser")
        
        PFGeoPoint.geoPointForCurrentLocation { (geoPoint:PFGeoPoint?, error:Error?) in
            
            if error != nil {
                print("Get user location error \(error?.localizedDescription)")
            }
        
            self.postBountyNearLocation(location: geoPoint!,
                 success: {
                    print("POST BOUNTY TEST SUCCESS")
                    expectation.fulfill()
            })
        }
        
        self.waitForExpectations(timeout: 60, handler: nil)
    }
    
    
    func postBountyNearLocation(location:PFGeoPoint, success:@escaping ()->()) {
        
        let user = PFUser.current() as! User
        
        let note = "POSTING 4rd BOUNTY WITH POI!"
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            self.poiServer.getLocationBy(coordinates: currentLocation!, radius: .nearby,
                success: { (poiArray:[POI]?) in
                    let firstPOI = poiArray?[3]
                    print("First POI name is \(firstPOI?.placeName)")
                    
                    //Look if we already have this POI
                    //If we do use that POI
                    //else use the new one.
                    
                    self.server.postBountyBy(user: user, withNote: note, atPOI: firstPOI!, withTokenValue: 10,
                         success: {
                            success()
                    },
                         failure: {
                            print("POST BOUNTY TEST FAILURE")
                    })
            },
                failure: { (error:Error?) in
                    
            })

        }
        
        
    }
    
    
    func testFetchBountyPostedByUser() {
        
        let expectation = self.expectation(description: "FetchBountyByUser")
        
        let user = PFUser.current() as! User
        
        server.fetchBountyPostedBy(user: user,
           success: { (bountiesArray:[XHERBounty]?) in
            
                let numberOfBounties = bountiesArray?.count
                
                print("There are \(numberOfBounties)")
                
                let firstBounty = bountiesArray?[0]
                
                if firstBounty?.bountyNote == "POSTING 9th BOUNTY!" {
                    print("Bounty note = \(firstBounty?.bountyNote)")
                    expectation.fulfill()
                }
        },
           failure: { (error:Error?) in
            
        })
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchBountyPostedByUserValidUser() {
        
        let expectation = self.expectation(description: "FetchBountyByUserValidUser")
        
        let user = PFUser.current() as! User
        
        server.fetchBountyPostedBy(user: user,
            success: { (bountiesArray:[XHERBounty]?) in
            
                let firstBounty = bountiesArray?[0]
                let user = firstBounty?.postedByUser
                
                if let userName = user?.username {
                    print("USER NAME IS \(userName)")
                    expectation.fulfill()
                }
            },
               failure: { (error:Error?) in
            
        })
        
        self.waitForExpectations(timeout: 10, handler: nil)
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
