//
//  Comment.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
class Comment: PFObject,PFSubclassing {
    
    
   
    
    
    var date : NSDate? {
        get {
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
    var text : String? {
        get {
            if let _date = self["text"] as? String{
                return _date
            }else{
                return ""
            }
            
        }
        set{
            self["text"] = newValue
        }
    }
    var user : User?
    var content : Content?
   
    public static func parseClassName() -> String {
        return "Comment"
    }


}
