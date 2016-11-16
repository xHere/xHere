//
//  Media.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

enum MediaType: Int {
    case image = 0, video, audio, unknown
}


class Media: PFObject,PFSubclassing {
    /**
     The name of the class as seen in the REST API.
     */
    
    var content:Content? {
        get {
            if let content = self["content"] {
                return content as? Content
            }
            return nil
        }
        set {
            self["content"] = newValue
        }
    }
//    var _contentArray:[PFObject] {
//        get {
//            if let returnArray = self["content"] {
//                return returnArray as! [PFObject]
//            }
//            let returnArray = [PFObject]()
//            return returnArray
//        }
//        set {
//            self["content"] = newValue
//        }
//    }
//    
//    var _contentArrayTyped:[Content]?
//    var content:Content {
//        
//        get {
//            
//            if _contentArrayTyped == nil {
//                _contentArrayTyped = [Content]()
//                
//                for object in _contentArray {
//                    let content = object as! Content
//                    _contentArrayTyped?.append(content)
//                }
//            }
//            return _contentArrayTyped![0]
//        }
//        set {
//            _contentArrayTyped = [Content]()
//            _contentArrayTyped?.append(newValue)
//            _contentArray.append(newValue)
//        }
//    }

    var mediaData : PFFile?{
        get {
            if let _mediaData = self["mediaData"] as? PFFile{
                return _mediaData
            }else{
                return nil
            }
            
        }
        set{
            if let newMedia = newValue {
                self["mediaData"] = newMedia
                self["mediaType"] = mediaType.rawValue as NSNumber
            }
        }
    }
    
    
    var mediaType : MediaType{
        get{
            if let _mediaType = self["mediaType"] as? Int{
               return MediaType(rawValue: _mediaType) ?? .unknown
            }else{
                return .unknown
            }
        }
        set{
            
            self["mediaType"] = newValue.rawValue as NSNumber
        }
    }
    
//    var belongToContent:Content {
//        get {
//            
//            return self.relation(forKey: "")
//            
//        }
//    }
    
    public static func parseClassName() -> String {
        return "Media"
    }
}
