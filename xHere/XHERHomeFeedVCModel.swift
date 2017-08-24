//
//  XHERHomeFeedVCModel.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 8/16/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation
import SVProgressHUD

typealias claimedAndUnClaimedBountiesCompletion = ((_ claimed:[XHERBounty], _ unclaimed:[XHERBounty])->Void)?

let searchDistanceInMiles:Double = 200.0

//protocol XHERHomeFeedVCModelDelegate {
//    func reloadData()
//}

class XHERHomeFeedVCModel {
        
    private var server: XHERServer!
    
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
    var nearUnClaimedArray = [XHERBountyViewCellModel]() {
        didSet {
            print("$$$$$$$$$$$ update near array")
        }
    }
    var farUnClaimedArray = [XHERBountyViewCellModel]() {
        didSet {
            print("$$$$$$$$$$ update far array")
        }
    }
    
    init(withServer server:XHERServer) {
        self.server = server
    }
    
    convenience init() {
        self.init(withServer: XHERServer.sharedInstance)
    }
    
    // Data fetch
    func getClaimedAndUnclaimedBountyNearBy(completion: claimedAndUnClaimedBountiesCompletion) {
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

// MARK: - Helper
extension XHERHomeFeedVCModel {
    func createNearAndFarArray(bounties:[XHERBounty]) -> (nearArray:[XHERBountyViewCellModel], farArray:[XHERBountyViewCellModel]) {
        
        var nearArray = [XHERBountyViewCellModel]()
        var farArray = [XHERBountyViewCellModel]()
        
        for bounty in bounties {
            
            let cellModel = XHERBountyViewCellModel(bounty)
            
            if bounty.distanceFromCurrentInMiles <= 10 {
                cellModel.isClaimed.value = false
                nearArray.append(cellModel)
            }
            else {
                cellModel.isClaimed.value = true
                farArray.append(cellModel)
            }
        }
        
        return (nearArray, farArray)
    }
}
