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
    
    
    // MARK: - Find Bounty by User
    func fetchBountyPostedBy(user:User, success:@escaping ([XHERBounty]?)->(), failure:@escaping (Error?)->()) {
        
        let bountyQuery = PFQuery(className: kPFClassBounty)
        bountyQuery.whereKey(kPFKeyPostedByUser, equalTo: user)
        bountyQuery.findObjectsInBackground { (contentsArray:[PFObject]?, error:Error?) in
            
            if error == nil {
                
                if let contentsArray = contentsArray {
                    
                    //Parse array of PFObject into Bounty
                    var bountyArrayTyped = [XHERBounty]()
                    for object in contentsArray {
                        let content = object as! XHERBounty
                        bountyArrayTyped.append(content)
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
        
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            if let error = error {
                print("XHERServer.uploadContent() currentLocation fetch failed = \(error.localizedDescription)")
                failure()
            }
            else {
            
                let newBounty = XHERBounty()
                
                //Set byUser
                newBounty.postedByUser = user
                
                //postedAtLocation
//                newBounty.postedAtLocation = poi
                
                //Notes on the bounty
                newBounty.bountyNote = note
                
                newBounty.bountyGeoPoint = currentLocation
                
                newBounty.bountyValue = value
                
                newBounty.isClaimed = false
                
                //Set this bounty as new
                newBounty.claimedByUser = nil
                
                newBounty.saveInBackground(block: { (saveSuccess:Bool, error:Error?) in
                    
                    if saveSuccess {
                        print("NEW BOUNTY SAVED!!")
                        success()
                    }
                    else {
                        print("POST BOUNTY FAILURE")
                        failure()
                    }
                })
            }
        }
    }
    
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
    func uploadContent(withText text:String, andImage image:UIImage?, andVideo:Data?, success:@escaping ()->(), failure:@escaping ()->()) {
        
        //Set GeoPoint to current location
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            
            if let error = error {
                print("XHERServer.uploadContent() currentLocation fetch failed = \(error.localizedDescription)")
                failure()
            }
            else {
                let content = Content()
                
                //Set current location
                content.geoPoint = currentLocation
                
                //Set content text
                content.detailDescription = text
                
                //Set date
                content.date = Date.init() as NSDate
                
                //Set user
                let currentUser = PFUser.current() as! User
                content.user = currentUser
                
                //Set Image
                if let image = image,
                    let imageData = UIImagePNGRepresentation(image),
                    let imageFile = PFFile(name:"image.png", data:imageData) {
                    
                    let media = Media()
                    media.mediaType = .image
                    media.mediaData = imageFile
                    
                    media.content = content
                    media.saveInBackground(block: { (saveSucess:Bool, error:Error?) in

                        if saveSucess {
                            content.mediaArray = [media]
                            do {
                                try content.save()
                                //Call success Block
                                success()
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
                    success()
                }
            }
        }
    }
    
    func uploadContent(withText text:String, andImage image:UIImage, success:@escaping ()->(), failure:@escaping ()->() ) {
        uploadContent(withText: text, andImage: image, andVideo: nil,
            success: {
            
                success()
            },
            failure: {
                
                failure()
            })
    }
    
    func uploadContent(withText text:String, success:@escaping ()->(), failure:@escaping ()->()) {
        uploadContent(withText: text, andImage: nil, andVideo: nil,
            success: {
                
                success()
            },
            failure: {
                        
                failure()
            })
    }
    
    func uploadContent(withImage image:UIImage, success:@escaping ()->(), failure:@escaping ()->()) {
        uploadContent(withText: "", andImage: image, andVideo: nil,
            success: {
                
                success()
            },
            failure: {
                
                failure()
            })
    }

    
    
}