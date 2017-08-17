//
//  XHERHomeFeedVCModel.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 8/16/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation

let searchDistanceInMiles:Double = 200.0

protocol XHERHomeFeedVCModelDelegate {
    
    var claimedBountiesArray: [XHERBounty]? {get set}
    var unClaimedBountiesArray: [XHERBounty]? {get set}
}

class XHERHomeFeedVCModel {
    
    var delegate: XHERHomeFeedVCModelDelegate?
    
    var server: XHERServer!
    
    init(withServer server:XHERServer, delegate:XHERHomeFeedVCModelDelegate?) {
        self.server = server
        self.delegate = delegate
    }
    
    convenience init() {
        self.init(withServer: XHERServer.sharedInstance, delegate:nil)
    }
    
    typealias claimedAndUnClaimedBounties = (_ claimed:[XHERBounty], _ unclaimed:[XHERBounty])->Void
    
    func getClaimedAndUnclaimedBountyNearBy(completion:@escaping claimedAndUnClaimedBounties) {
        
        server.fetchClaimedAndUnClaimedBountyNearHere(withInMiles: searchDistanceInMiles, success: { [weak self] (claimedArray, unclaimedArray) in
            
            let solidClaimedArray = claimedArray ?? [XHERBounty]()
            let solidUnClaimedArray = unclaimedArray ?? [XHERBounty]()
            completion(solidClaimedArray, solidUnClaimedArray)
            
            self?.delegate?.claimedBountiesArray = solidClaimedArray
            self?.delegate?.unClaimedBountiesArray = solidUnClaimedArray
            
        }, failure: { (error) in
            print("Error: getClaimedAndUnclaimedBountyNearBy:")
        })
    }
    
}
