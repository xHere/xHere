//
//  Content.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
class Content: PFObject,PFSubclassing {
    
    
    
  

    
    var mediaObject : Media?
    var poi : POI?
    var user : User?
    
    
    var contentID : NSNumber?{
        get{
            if let _contentID = self["contentID"] as? NSNumber{
                return _contentID
            }else{
                return 0
            }
        }
        set{
            self["contentID"] = newValue
        }
    }
    
    var place : String?{
        get{
            if let _place = self["place"] as? String{
                return _place
            }else{
                return ""
            }
        }
        set{
            self["contentID"] = newValue
        }
    }
    var date : NSDate?{
        get{
            if let _date = self["date"] as? NSDate{
                return _date
            }else{
                return nil
            }
        }
        set{
            self["date"] = newValue
        }
    }
    var text : String?{
        get{
            if let _text = self["text"] as? String{
                return _text
            }else{
                return ""
            }
        }
        set{
            self["text"] = newValue
        }
    }
    var detailDescription : String?{
        get{
            if let _detailDescription = self["detailDescription"] as? String{
                return _detailDescription
            }else{
                return ""
            }
        }
        set{
            self["detailDescription"] = newValue
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
        return "Content"
    }

   
    
   

}
