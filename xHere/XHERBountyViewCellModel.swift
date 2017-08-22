//
//  XHERBountyViewModel.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 8/18/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation

protocol XHERBountyViewCellModelDelegate {

    var locationTitleLabel: UILabel {get set}
    var distanceLabel: UILabel {get set}
    
    var bountyNotesLabel: UILabel {get set}
    var claimITLabel: UILabel {get set}
    var dateUpdatedAtLabel: UILabel {get set}

    var postedByUserLabel: UILabel {get set}
    var userProfileImage: UIImageView {get set}
}

class XHERBountyViewCellModel {
    
    private var bounty: XHERBounty! {
        didSet {
            self.setModel(self.bounty)
        }
    }

    var locationTitle: Box<String> = Box("")
    var distanceText: Box<String> = Box("")
    var bountyNotesText: Box<String> = Box("")
    var isClaimed: Box<Bool> = Box(false)
    var updatedDate: Box<String> = Box("")
    var posedByUser: Box<String> = Box("")
    var userProfileImage: Box<URL> = Box(URL(string: "")!)
    
    init(_ model:XHERBounty) {
        self.bounty = model
    }
    
    func setModel(_ model:XHERBounty) {
        
        //Location Name
        self.locationTitle.value = bounty.postedAtLocation.placeName ?? ""
        
        //Location in miles
        let distance = self.roundToPlaces(value: bounty.postedAtLocation.distanceFromCurrentInMiles, decimalPlaces: 2)
        self.distanceText.value = "\(distance) mi"
        self.bountyNotesText.value = bounty.bountyNote
        self.isClaimed.value = bounty.isClaimed
        
        //Created Date
        if let createdDate = bounty.createdAt {
            self.updatedDate.value = getCurrentDate(updatedDate: createdDate)
        }
        
        //User name and profile pic
        if let user = bounty.postedByUser {
            self.posedByUser.value = user.username ?? ""
        }
        if let profileImage = bounty.postedByUser?.profileImageUrl {
            userProfileImage.value = profileImage
        }
        
    }
    
    
}

extension XHERBountyViewCellModel {
    func getCurrentDate(updatedDate:Date)->String{
        xHereDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        xHereDateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        xHereDateFormatter.dateFormat = "MM/dd HH:mm"
        xHereDateFormatter.timeZone = NSTimeZone.local
        let timeStamp = xHereDateFormatter.string(from: updatedDate)
        return timeStamp
    }
    
    func roundToPlaces(value: Double, decimalPlaces: Int) -> Double {
        let divisor = pow(10.0, Double(decimalPlaces))
        return round(value * divisor) / divisor
    }
    
}



class Box<T> {
    
    typealias DidChanged = ((_ value:T)->Void)
    var value:T
    var changed:DidChanged?
    
    
    init(_ value:T) {
        self.value = value
    }
    
    func bind(changed:@escaping DidChanged) {
        self.changed = changed
        self.changed?(self.value)
    }
}
