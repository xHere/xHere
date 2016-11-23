//
//  POI.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class POI: PFObject, PFSubclassing {
    
    var googlePlaceID:String {
        get {
            if let returnString = self[kPFKeyGooglePlaceID] {
                return returnString as! String
            }
            return ""
        }
        set {
            self[kPFKeyGooglePlaceID] = newValue as NSString
        }
    }
    
    var placeName : String? {
        get {
            if let returnStrig = self[kPFKeyPOIName] as? String {
                return returnStrig
            }
            
            return ""
            
        }
        set {
            if let newValue = newValue {
                self[kPFKeyPOIName] = newValue
            }
        }
    }

    var placeImageURL : URL?
    var latitute : Double = 0.0
    var longitude : Double = 0.0
    
    
    

    var user : User?
    var content : Content?
    var comment : Comment?
    var title:String!
    var POIId : NSNumber?{
        get{
            if let _POIId = self["POIId"] as? NSNumber{
                return _POIId
            }else{
                return 0
            }
        }
        set{
            self["POIId"] = newValue
        }
    }
    var geoPoint : PFGeoPoint?{
        get{
            if let _geoPoint = self["geoPoint"] as? PFGeoPoint{
                return _geoPoint
            }else{
                return nil
            }
        }
        set{
            self["geoPoint"] = newValue
            
        }
    }
    
    public static func parseClassName() -> String {
        return "POI"
    }
    public func initWithDictionary(dictionary : NSDictionary){
        
        googlePlaceID = dictionary["place_id"] as? String ?? ""
        
        placeName = dictionary["name"] as? String
        let geometry = dictionary["geometry"] as? NSDictionary
        let loc = geometry?["location"] as? NSDictionary
        
        latitute = (loc?["lat"] as? Double)!
        longitude = (loc?["lng"] as? Double)!
        
        let photos = dictionary["photos"] as? NSArray
        if let photos = photos{
            let pics = photos[0] as! NSDictionary

            let width = pics["width"]!
            _ = pics["height"]!
            let photReference = pics["photo_reference"]!
            let strUrl = "\(kGoogleWebserviceBasePath)photo?maxwidth=\(width)&photoreference=\(photReference)&key=\(kPFGoogleApiKey)"
            placeImageURL = URL(string: strUrl)
        }
        
        geoPoint = PFGeoPoint(latitude:latitute, longitude:longitude)
      
        
        
        
    }

}
