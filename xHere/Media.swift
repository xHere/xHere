//
//  Media.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
class Media: PFObject,PFSubclassing {
    /**
     The name of the class as seen in the REST API.
     */
    


    var mediaData : PFFile?{
        get {
            if let _mediaData = self["mediaData"] as? PFFile{
                return _mediaData
            }else{
                return nil
            }
            
        }
        set{
            self["mediaData"] = newValue
        }
    }
    var mediaType : Int?{
        get{
            if let _mediaType = self["mediaType"] as? Int{
               return _mediaType
            }else{
                return 0
            }
        }
        set{
            
            self["mediaType"] = newValue
        }
    }
    
    public static func parseClassName() -> String {
        return "Media"
    }
}
