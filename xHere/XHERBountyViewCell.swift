//
//  XHERHomeFeedViewCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERBountyViewCell: UITableViewCell {
    

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var bountyNotesLabel: UILabel!
    @IBOutlet weak var claimITLabel: UILabel!

    @IBOutlet weak var claimedImage: UIImageView!
    var bounty: XHERBounty! {
        
        didSet {
            self.locationTitleLabel.text = bounty.postedAtLocation.title
            
            self.postedByUserLabel.text = bounty.postedByUser?.username
            self.bountyNotesLabel.text = bounty.bountyNote
            
            let poi = bounty.postedAtLocation
            locationTitleLabel.text = poi.placeName
            if let poiImage = poi.placeImageURL {
                claimedImage.setImageWith(poiImage)
            }
            
        }
    }
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//
//        claimITLabel.layer.cornerRadius = 5.0
//        
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "XHERBountyViewCell", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        cellContentView.frame = bounds
   
        contentView.addSubview(cellContentView)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        locationTitleLabel.text = ""
        postedByUserLabel.text = ""
        bountyNotesLabel.text = ""
        claimedImage.image = nil
    }
    
    override func layoutSubviews() {
        cellContentView.frame = bounds
    }
    
}
