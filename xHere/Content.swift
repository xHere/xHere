//
//  Content.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class Content: NSObject {
    
    var contentID : NSNumber!
    var place : String!
    var date : String!
    var text : String!
    var detailDescription: String?
    var latitude : Double?
    var longitude : Double?

    
    var mediaObject : Media?
    var poi : POI?
    var user : User?

}
