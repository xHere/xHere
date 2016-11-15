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
    
    
    // MARK: - Download Content API
    func download(content:Content, success:()->(), failure: ()->()) {
        
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
                content.user = PFUser.current() as! User?
                
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
