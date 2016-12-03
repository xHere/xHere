//
//  XHERHomeFeedViewCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERHomeFeedViewCell: UITableViewCell {
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var bountyNotesLabel: UILabel!

    @IBOutlet weak var claimedImage: UIImageView!
    var bounty: XHERBounty! {
        
        didSet {
//            self.locationTitleLabel.text = bounty.postedAtLocation.title
            
            self.postedByUserLabel.text = bounty.postedByUser?.username
            self.bountyNotesLabel.text = bounty.bountyNote
            if bounty.isClaimed == true {
                print(bounty.mediaArray?[0].mediaData?.url!)
                let media = bounty.mediaArray?[0]
                let mData  = media!.mediaData
                let url = URL(string: (media?.mediaData?.url!)!)
                self.claimedImage.setImageWith(url!)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        let test = "testing"
        
        // Configure the view for the selected state
    }
    
}
