//
//  User.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse


class User : PFUser {
    
    var objectID: String?{
        
            get {
                return self["objectId"] as? String
            }
        

    }
    
    override var username : String? {
        get {
            if let _username = self["username"] as? String{
                return _username
            }else{
                return ""
            }
            
        }
        set{
            self["username"] = newValue
        }
    }
    
    var firstName : String? {
        get {
            if let _firstName = self["firstName"] as? String{
                return _firstName
            }else{
                return ""
            }
            
        }
        set{
            self["firstName"] = newValue
        }
    }
    
    var lastName : String?{
        get {
            if let _lastName = self["lastName"] as? String{
                return _lastName
            }else{
                return ""
            }
            
        }
        set{
            self["lastName"] = newValue
        }
    }
    var screenName : String?{
        get {
            if let _screenName = self["screenName"] as? String{
                return _screenName
            }else{
                return ""
            }
            
        }
        set{
            self["screenName"] = newValue
        }
    }
    
    override var email : String?{
        get {
            if let _email = self["email"] as? String{
                return _email
            }else{
                return ""
            }
        }
        set{
            self["email"] = newValue
        }
    }
    
    var profileImageData:Data?
    var profileImageFile : PFFile?{
        get {
            if let _profileImageUrl = self[kPFKeyProfileImageFile] as? PFFile{
                return _profileImageUrl
            }else{
                return nil
            }
           
        }
        set{
            self[kPFKeyProfileImageFile] = newValue
        }
    }
    
    var profileImageUrl:URL? {
        get {
            if let profileImageURL = self[kPFKeyProfileImageURL] as? String {
                return URL(string: profileImageURL)
            }
            else {
                return nil
            }
        }
    }
    
    var coverPictureUrl : String? {
        get {
            if let _coverPictureUrl = self["coverPictureUrl"] as? String {
                return _coverPictureUrl
            }
            else {
                return nil
            }
        }
        set{
            self["coverPictureUrl"] = newValue
        }
    }
    
    var tokens : Int {
        get {
            if let tokens = self[kPFKeyTokens] as? Int {
                return tokens
            }
            else {
                return 0
            }
        }
        set {
            self[kPFKeyTokens] = newValue
        }
    }
    
    var coverPictureUrl : String? {
        get {
            if let _coverPictureUrl = self["coverPictureUrl"] as? String {
                return _coverPictureUrl
            }
            else {
                return nil
            }
        }
        set{
            self["coverPictureUrl"] = newValue
        }
    }
    
//    var contentByUser:[Content]? {
//        
//        get {
//            return self["contentByUser"] as! PFRelation
//        }
//    }
    
    var poi : POI?

    var comment : Comment?
    
//    override class func initialize() {
//
//        
//        self.registerSubclass()
//        
//    }
//    
//    override static func parseClassName() -> String {
//        return "User"
//    }
    
    
}
