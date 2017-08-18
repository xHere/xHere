//
//  XHERHomeFeedVCModel.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 8/16/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation
import SVProgressHUD

let searchDistanceInMiles:Double = 200.0

protocol XHERHomeFeedVCModelDelegate {
    func reloadData()
}

class XHERHomeFeedVCModel {
    
    var delegate: XHERHomeFeedVCModelDelegate?
    
    var server: XHERServer!
    
    var claimedArray = [XHERBounty]() {
        didSet {
        }
    }
    var unClaimedArray = [XHERBounty]() {
        didSet {
            let tuple = createNearAndFarArray(bounties: unClaimedArray)
            nearUnClaimedArray = tuple.nearArray
            farUnClaimedArray = tuple.farArray
        }
    }
    var nearUnClaimedArray = [XHERBounty]() {
        didSet {
            print("$$$$$$$$$$$ update near array")
        }
    }
    var farUnClaimedArray = [XHERBounty]() {
        didSet {
            print("$$$$$$$$$$ update far array")
        }
    }
    
    init(withServer server:XHERServer, delegate:XHERHomeFeedVCModelDelegate?) {
        self.server = server
        self.delegate = delegate
    }
    
    convenience init() {
        self.init(withServer: XHERServer.sharedInstance, delegate:nil)
    }
    
    // Data fetch
    typealias claimedAndUnClaimedBounties = ((_ claimed:[XHERBounty], _ unclaimed:[XHERBounty])->Void)?
    func getClaimedAndUnclaimedBountyNearBy(completion: claimedAndUnClaimedBounties) {
        SVProgressHUD.show()
        server.fetchClaimedAndUnClaimedBountyNearHere(withInMiles: searchDistanceInMiles, success: { [weak self] (claimedArray, unclaimedArray) in
            
            if let strongSelf = self {
                
                strongSelf.claimedArray = claimedArray ?? strongSelf.claimedArray
                strongSelf.unClaimedArray = unclaimedArray ?? strongSelf.unClaimedArray
                
                completion?(strongSelf.claimedArray, strongSelf.unClaimedArray)
            }
        }, failure: { (error) in
            print("Error: getClaimedAndUnclaimedBountyNearBy:")
        })
    }
}

//Helper
extension XHERHomeFeedVCModel {
    func createNearAndFarArray(bounties:[XHERBounty]) -> (nearArray:[XHERBounty], farArray:[XHERBounty]) {
        
        var nearArray = [XHERBounty]()
        var farArray = [XHERBounty]()
        
        for bounty in bounties {
            bounty.distanceFromCurrentInMiles <= 10 ? nearArray.append(bounty) : farArray.append(bounty)
        }
        
        return (nearArray, farArray)
    }
}
