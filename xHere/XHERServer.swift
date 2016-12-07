//
//  xHERServer.swift
//  xHere
//
//  Created by Developer on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHERServer: NSObject {
    
    
    static let sharedInstance = XHERServer()
    
    
    // MARK: - Bounty API
    enum PostOrClaimed: String {
        case postBy = "postedByUser", claimed = "claimedByUser"
    }
    
    
    // MARK: - Fetch Bounty API by location
    
    // Find Claimed Bounty at a particular POI
    func fetchClaimedBountyAt(poi:POI, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        //Check if the POI submitted is already on the server or not.
        let duplicatePOIQuery = PFQuery(className: kPFClassPOI)
        duplicatePOIQuery.whereKey(kPFKeyGooglePlaceID, equalTo: poi.googlePlaceID)
        duplicatePOIQuery.getFirstObjectInBackground(block: { (poiObject:PFObject?, error:Error?) in
            
            var uniquePOI:POI
            if let poiObject = poiObject {
                uniquePOI = poiObject as! POI
            }
            else {
                uniquePOI = poi
            }
            
            uniquePOI.saveInBackground()
        
            let bountyQuery = PFQuery(className: kPFClassBounty)
            bountyQuery.whereKey(kPFKeyPOI, equalTo: uniquePOI)
            bountyQuery.includeKey(kPFKeyPOI)
            bountyQuery.includeKey(kPFKeyPostedByUser)
            bountyQuery.includeKey(kPFKeyClaimedByUser)
            bountyQuery.whereKey(kPFKeyBountyIsClaimed, equalTo: true)
            bountyQuery.order(byDescending: "createdAt")
            bountyQuery.findObjectsInBackground { (bountiesArray:[PFObject]?, error:Error?) in
                
                if error == nil {
                    
                    if let bountiesArray = bountiesArray {
                        
                        //Parse array of PFObject into Bounty
                        var bountyArrayTyped = [XHERBounty]()
                        for object in bountiesArray {
                            let bounty = object as! XHERBounty
                            
                            if let distanceFromCurrentInMiles = bounty.postedAtLocation.geoPoint?.distanceInMiles(to: poi.geoPoint) {
                                bounty.postedAtLocation.distanceFromCurrentInMiles = distanceFromCurrentInMiles
                            }
                            
                            bountyArrayTyped.append(bounty)
                        }
                        
                        //Return nil if the array is empty
                        if bountyArrayTyped.count > 0 {
                            success(bountyArrayTyped)
                        }
                        else {
                            success(nil)
                        }
                    }
                }
                else {
                    failure(error)
                }
            }
        })
    }
    
    // Find Bounty Claimed in an area
    func fetchUnClaimedBountyNear( location:PFGeoPoint, withInMiles miles:Double, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        fetchBountyNear(location: location, withInMiles: miles, thatIsClaimed: false,
                        
                        success: { (bountiesArray:[XHERBounty]?) in
                            success(bountiesArray)
        },
                        failure: { (error:Error?) in
                            failure(error)
        })
    }
    
    func fetchClaimedBountyNear( location:PFGeoPoint,withInMiles miles:Double, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        fetchBountyNear(location: location, withInMiles: miles, thatIsClaimed: true,
                        success: { (bountiesArray:[XHERBounty]?) in
                            success(bountiesArray)
        },
                        failure: { (error:Error?) in
                            failure(error)
        })
    }
    
    private func fetchBountyNear( location:PFGeoPoint, withInMiles miles:Double, thatIsClaimed isClaimed:Bool, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        let bountyQuery = PFQuery(className: kPFClassBounty)
        bountyQuery.whereKey(kPFKeyGeoPoint, nearGeoPoint: location, withinMiles: miles)
        bountyQuery.includeKey(kPFKeyPOI)
        bountyQuery.includeKey(kPFKeyPostedByUser)
        bountyQuery.includeKey(kPFKeyMediaArray)
        bountyQuery.includeKey(kPFKeyClaimedByUser)
        bountyQuery.whereKey(kPFKeyBountyIsClaimed, equalTo: isClaimed)
        
        bountyQuery.order(byDescending: "createdAt")
        bountyQuery.findObjectsInBackground { (bountiesArray:[PFObject]?, error:Error?) in
            
            if error == nil {
                
                if let bountiesArray = bountiesArray {
                    var bountyArrayTyped = [XHERBounty]()
                    for object in bountiesArray {
                        let bounty = object as! XHERBounty
                        
                        if let distanceFromCurrentInMiles = bounty.bountyGeoPoint?.distanceInMiles(to: location) {
                            bounty.distanceFromCurrentInMiles = distanceFromCurrentInMiles
                        }
                        
                        if let distanceFromCurrentInMiles = bounty.postedAtLocation.geoPoint?.distanceInMiles(to: location) {
                            bounty.postedAtLocation.distanceFromCurrentInMiles = distanceFromCurrentInMiles
                        }
                        
                        bountyArrayTyped.append(bounty)
                    }
                    
                    if bountyArrayTyped.count > 0 {
                        success(bountyArrayTyped)
                    }
                    else {
                        success(nil)
                    }
                }
            }
            else {
                failure(error)
            }
        }
    }
    
    // MARK: - Fetch Bounty baseed by User
    
    // Find Bounty claimed by User
    func fetchBountyEarneddBy(user:User, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        fetchRelatedTo(user: user, byPostEarned: .claimed,
                       success: { (bountiesArray:[XHERBounty]?) in
                        
                        success(bountiesArray)
            },
                       failure: { (error:Error?) in
                        
                        failure(error)
        })
        
    }
    
    // Find Bounty posted by user
    func fetchBountyPostedBy(user:User, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        fetchRelatedTo(user: user, byPostEarned: .postBy,
                       success: { (bountiesArray:[XHERBounty]?) in
                        
                        success(bountiesArray)
            },
                       failure: { (error:Error?) in
                        
                        failure(error)
        })
    }
    
    // Find Bounty posted by User
    func fetchRelatedTo(user:User,byPostEarned postOrEarned:PostOrClaimed,  success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        let bountyQuery = PFQuery(className: kPFClassBounty)
        bountyQuery.whereKey(postOrEarned.rawValue, equalTo: user)
        bountyQuery.includeKey(postOrEarned.rawValue)
        bountyQuery.includeKeys([kPFKeyMediaArray, kPFKeyPostedByUser, kPFKeyPOI, kPFKeyClaimedByUser])
        
        bountyQuery.order(byDescending: "createdAt")
        bountyQuery.findObjectsInBackground { (bountiesArray:[PFObject]?, error:Error?) in
            
            if error == nil {
                
                if let bountiesArray = bountiesArray {
                    
                    //Parse array of PFObject into Bounty
                    var bountyArrayTyped = [XHERBounty]()
                    for object in bountiesArray {
                        let bounty = object as! XHERBounty
                        
                        bountyArrayTyped.append(bounty)
                    }
                    
                    //Return nil if the array is empty
                    if bountyArrayTyped.count > 0 {
                        success(bountyArrayTyped)
                    }
                    else {
                        success(nil)
                    }
                }
            }
            else {
                failure(error)
            }
        }
    }
    
    // MARK: - Post Bounty
    
    func postBountyBy(user:User, withNote note:String, atPOI poi:POI, withTokenValue value:Int, success:@escaping ()->(), failure:@escaping ()->()) {
        
        let newBounty = XHERBounty()
        
        //Set byUser
        newBounty.postedByUser = user
        
        //Check if the POI submitted is already on the server or not.
        let duplicatePOIQuery = PFQuery(className: kPFClassPOI)
        duplicatePOIQuery.whereKey(kPFKeyGooglePlaceID, equalTo: poi.googlePlaceID)
        
        duplicatePOIQuery.getFirstObjectInBackground(block: { (poiObject:PFObject?, error:Error?) in
            
            var uniquePOI:POI
            if let poiObject = poiObject {
                uniquePOI = poiObject as! POI
            }
            else {
                uniquePOI = poi
            }
            
            uniquePOI.saveInBackground()
            //postedAtLocation
            newBounty.postedAtLocation = uniquePOI
            
            //Notes on the bounty
            newBounty.bountyNote = note
            
            newBounty.bountyGeoPoint = uniquePOI.geoPoint
            
            
            
            
            newBounty.isClaimed = false
            
            //Set this bounty as new
            newBounty.claimedByUser = nil
            
            if user.tokens > 1 {
                newBounty.bountyValue = value
                user.tokens = user.tokens - value
            }

            newBounty.saveInBackground(block: { (saveSuccess:Bool, error:Error?) in
                
                if saveSuccess {
                    print("NEW BOUNTY SAVED!!")
                    user.saveInBackground(block: { (saveSuccess:Bool, error:Error?) in
                        success()
                    })
                }
                else {
                    print("POST BOUNTY FAILURE \(error?.localizedDescription)")
                    failure()
                }
            })
            
        })
        
        
    }
    
    //MARK claimBounty
    func claimBounty(user : User, objectId: String, image: UIImage, success : @escaping (XHERBounty, Int) -> (), faliure : @escaping (Error) -> ()){
        
        
        let query = PFQuery(className:kPFClassBounty)
        query.includeKey("mediaArray")
        
        query.getObjectInBackground(withId: objectId) { (bountyObject : PFObject?, error: Error?) in
            if error == nil {
                let bounty = bountyObject as! XHERBounty
        

                self.uploadContent(withImage: image, success: { (media: Media) in
                    bounty.claimedByUser  = user
//                    let relation = bounty.relation(forKey: kPFKeyClaimedByUser)
//                    relation.add(user)
                    bounty.isClaimed  = true
                    let temp = [media]
                    bounty.mediaArray = temp
                    user.tokens = user.tokens + bounty.bountyValue
                    bounty.bountyValue = 0
                    bounty.saveInBackground()
                    user.saveInBackground()
                    success(bounty, bounty.bountyValue)
                    }, failure: {
                        
                })
            }
            else {
                faliure(error!)
            }
            
        }
    }
    
    
    //    func postBountyBy(user:User, withNote note:String, atPOI poi:POI, withTokenValue value:Int, success:@escaping ()->(), failure:@escaping ()->()) {
    //
    //        print("BEGIN GETTING LOCATION")
    //        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
    //            if let error = error {
    //                print("XHERServer.uploadContent() currentLocation fetch failed = \(error.localizedDescription)")
    //                failure()
    //            }
    //            else {
    //
    //                let newBounty = XHERBounty()
    //
    //                //Set byUser
    //                newBounty.postedByUser = user
    //
    //                //Check if the POI submitted is already on the server or not.
    //                let duplicatePOIQuery = PFQuery(className: kPFClassPOI)
    //                duplicatePOIQuery.whereKey(kPFKeyGooglePlaceID, equalTo: poi.googlePlaceID)
    //
    //                duplicatePOIQuery.getFirstObjectInBackground(block: { (poiObject:PFObject?, error:Error?) in
    //
    //                    var uniquePOI:POI
    //                    if let poiObject = poiObject {
    //                        uniquePOI = poiObject as! POI
    //                    }
    //                    else {
    //                        uniquePOI = poi
    //                    }
    //
    //                    uniquePOI.saveInBackground()
    //                    //postedAtLocation
    //                    newBounty.postedAtLocation = uniquePOI
    //
    //                    //Notes on the bounty
    //                    newBounty.bountyNote = note
    //
    //                    newBounty.bountyGeoPoint = currentLocation
    //
    //                    newBounty.bountyValue = value
    //
    //                    newBounty.isClaimed = false
    //
    //                    //Set this bounty as new
    //                    newBounty.claimedByUser = nil
    //
    //                    newBounty.saveInBackground(block: { (saveSuccess:Bool, error:Error?) in
    //
    //                        if saveSuccess {
    //                            print("NEW BOUNTY SAVED!!")
    //                            success()
    //                        }
    //                        else {
    //                            print("POST BOUNTY FAILURE \(error?.localizedDescription)")
    //                            failure()
    //                        }
    //                    })
    //
    //                })
    //            }
    //        }
    //    }
    
    // MARK: - Download Content API by User
    func downloadContentBy(user:User, success:@escaping ([Content]?)->(), failure: @escaping (Error?)->()) {
        
        let userQuery = PFQuery(className: kPFClassContent)
        userQuery.whereKey(kPFKeyUser, equalTo: user)
        userQuery.includeKey(kPFKeyMediaArray)
        userQuery.findObjectsInBackground { (contentsArray:[PFObject]?, error:Error?) in
            
            if error == nil {
                
                if let contentsArray = contentsArray {
                    
                    //Parse array of PFObject into Content
                    var contentsArrayTyped = [Content]()
                    for object in contentsArray {
                        let content = object as! Content
                        contentsArrayTyped.append(content)
                    }
                    
                    //Return nil if the array is empty
                    if contentsArrayTyped.count > 0 {
                        success(contentsArrayTyped)
                    }
                    else {
                        success(nil)
                    }
                }
            }
            else {
                failure(error)
            }
        }
    }
    
    
    
    // MARK: - Upload Content API
    func uploadContent(withText text:String, andImage image:UIImage?, andVideo:Data?, success:@escaping (Media)->(), failure:@escaping ()->()) {
        
        //Set GeoPoint to current location
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            
            if let error = error {
                print("XHERServer.uploadContent() currentLocation fetch failed = \(error.localizedDescription)")
                failure()
            }
            else {
                let content = Content()
                let media = Media()
                
                //Set current location
                content.geoPoint = currentLocation
                
                //Set content text
                content.detailDescription = text
                
                //Set date
                content.date = Date.init() as NSDate
                
                //Set user
                let currentUser = PFUser.current() as! User
                content.user = currentUser
                
                //Set Image®
                if let image = image,
                    let imageData = UIImageJPEGRepresentation(image, 0.0),
                    let imageFile = PFFile(name:"newimage.jpeg", data:imageData) {
                    
                    //  let media = Media()
                    media.mediaType = .image
                    media.mediaData = imageFile
                    
                    media.content = content
                    media.saveInBackground(block: { (saveSucess:Bool, error:Error?) in
                        
                        if saveSucess {
                            content.mediaArray = [media]
                            do {
                                try content.save()
                                //Call success Block
                                success(media)
                            }
                            catch {
                                print("Saving to media table failure")
                                failure()
                            }
                        }
                        else {
                            failure()
                        }
                    })
                    //
                    //Relation Code
                    //                    content.mediaArray.append(media)
                    //                    content.mediaRelations.add(media)
                    //
                    //                    media.saveInBackground(block: { (saveScuccss:Bool, error:Error?) in
                    //
                    //                        if saveScuccss {
                    //                            do {
                    //                                try content.save()
                    //                                //Call success Block
                    //                                success()
                    //                            }
                    //                            catch {
                    //                                print("Saving to media table failure")
                    //                                failure()
                    //                            }
                    //                        }
                    //                        failure()
                    //                    })
                }
                else {
                    //Call success Block
                    success(media)
                }
            }
        }
    }
    
    func uploadContent(withText text:String, andImage image:UIImage, success:@escaping (Media)->(), failure:@escaping ()->() ) {
        uploadContent(withText: text, andImage: image, andVideo: nil,
                      success: { (media : Media) in
                        
                        success(media)
            },
                      failure: {
                        
                        failure()
        })
    }
    
    func uploadContent(withText text:String, success:@escaping (Media)->(), failure:@escaping ()->()) {
        uploadContent(withText: text, andImage: nil, andVideo: nil,
                      success: { (media: Media) in
                        
                        success(media)
            },
                      failure: {
                        
                        failure()
        })
    }
    
    func uploadContent(withImage image:UIImage, success:@escaping (Media)->(), failure:@escaping ()->()) {
        uploadContent(withText: "", andImage: image, andVideo: nil,
                      success: { (media: Media) in
                        
                        success(media)
            },
                      failure: {
                        
                        failure()
        })
    }
    
    
    
}

