//
//  POI.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class POI: PFObject,PFSubclassing {
    
   

    var user : User?
    var content : Content?
    var comment : Comment?
    
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

}
