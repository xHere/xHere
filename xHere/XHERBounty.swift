//
//  XHERBounty.swift
//  xHere
//
//  Created by Developer on 11/16/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHERBounty: PFObject, PFSubclassing {

    
    private var _userArray:[PFObject]? {
        
        get {
            if let returnArray = self[kPFKeyPostedByUser] { //Return an array only if it's not empty
                if (returnArray as! [PFObject]).count > 0 {
                    return returnArray as? [PFObject]
                }
            }
            
            return nil
        }
        
        set {
            self[kPFKeyPostedByUser] = newValue
        }
    }
    
    var _userArrayTyped:[User]?
    var postedByUser:User? {
        get {
            
            if _userArrayTyped != nil { //If an array of Media is loaded
                return _userArrayTyped?[0]
            }
            if let _userArray = _userArray { //If not load an array of PFObject into array of Media
                _userArrayTyped = [User]()
                for object in _userArray {
                    let user = object as! User
                    _userArrayTyped?.append(user)
                }
                return _userArrayTyped?[0]
            }
            return nil
        }
        set {
            
            var newUserArray = [User]()
            if let newValue = newValue {
                newUserArray.append(newValue)
                _userArrayTyped = newUserArray
                _userArray = newUserArray
            }
        }
    }

//    var postedByUser:User? {
//        get {
//            return self[kPFKeyPostedByUser] as! User
//        }
//        set {
//            self[kPFKeyPostedByUser] = newValue
//        }
//    }
    
    private var _claimedByUserArray:[PFObject]? {
        
        get {
            if let returnArray = self[kPFKeyClaimedByUser] { //Return an array only if it's not empty
                if (returnArray as! [PFObject]).count > 0 {
                    return returnArray as? [PFObject]
                }
            }
            
            return nil
        }
        
        set {
            self[kPFKeyClaimedByUser] = newValue
        }
    }
    
    var _claimedByUserArrayTyped:[User]?
    var claimedByUser:User? {
        get {
            
            if _claimedByUserArrayTyped != nil { //If an array of Media is loaded
                return _claimedByUserArrayTyped?[0]
            }
            if let _claimedByUserArray = _claimedByUserArray { //If not load an array of PFObject into array of Media
                _claimedByUserArrayTyped = [User]()
                for object in _claimedByUserArray {
                    let user = object as! User
                    _claimedByUserArrayTyped?.append(user)
                }
                return _claimedByUserArrayTyped?[0]
            }
            return nil
        }
        set {
            
            var newUserArray = [User]()
            if let newValue = newValue {
                newUserArray.append(newValue)
                _claimedByUserArrayTyped = newUserArray
                _claimedByUserArray = newUserArray
            }
        }
    }
//    var claimedByUser:User? {
//        get {
//            return self[kPFKeyClaimedByUser] as? User
//        }
//        set {
//            if let newValue = newValue {
//                self[kPFKeyClaimedByUser] = newValue
//            }
//            else {
//                self[kPFKeyClaimedByUser] = NSNull()
//            }
//        }
//    }
    
    var postedAtLocation:POI {
        
        get {
            return self[kPFKeyPOI] as! POI
        }
        set {
            self[kPFKeyPOI] = newValue
        }
    }
    
    var bountyNote:String {
        get{
            if let _detailDescription = self[kPFKeyBountyNote] as? String{
                return _detailDescription
            }else{
                return ""
            }
        }
        set{
            self[kPFKeyBountyNote] = newValue
        }
    }
    
    var bountyGeoPoint:PFGeoPoint?{
        get{
            if let _geoPoint = self[kPFKeyGeoPoint] as? PFGeoPoint{
                return _geoPoint
            }else{
                return nil
            }
        }
        set{
            self[kPFKeyGeoPoint] = newValue
        }
    }

    var bountyValue:Int {
        get {
            return (self[kPFKeyTokens] as? Int) ?? 0
        }
        set {
            self[kPFKeyTokens] = newValue as NSNumber
        }
    }
    
    var isClaimed:Bool {
        get {
            if let claimed = self[kPFKeyBountyIsClaimed] as? NSNumber {
                return claimed.boolValue
            }
            else {
                return false
            }
        }
        set {
            self[kPFKeyBountyIsClaimed] = NSNumber(value: newValue)
        }
    }
    
    private var _mediaArray:[PFObject]? {
        
        get {
            if let returnArray = self[kPFKeyMediaArray] { //Return an array only if it's not empty
                if (returnArray as! [PFObject]).count > 0 {
                    return returnArray as? [PFObject]
                }
            }
            
            return nil
        }
        
        set {
            self[kPFKeyMediaArray] = newValue
        }
    }
    
    var _mediaArrayTyped:[Media]?
    var mediaArray:[Media]? {
        get {
            
            if _mediaArrayTyped != nil { //If an array of Media is loaded
                return _mediaArrayTyped
            }
            if let _mediaArray = _mediaArray { //If not load an array of PFObject into array of Media
                _mediaArrayTyped = [Media]()
                for object in _mediaArray {
                    let media = object as! Media
                    _mediaArrayTyped?.append(media)
                }
                return _mediaArrayTyped!
            }
            return nil
        }
        set {
            _mediaArrayTyped = newValue
            _mediaArray = newValue
        }
    }

    
    
    public static func parseClassName() -> String {
        return kPFClassBounty
    }
    
    
}
