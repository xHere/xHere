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
    @IBOutlet weak var customContentView: UIView!

    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    @IBOutlet weak var bountyNotesLabel: UILabel!
    @IBOutlet weak var claimITLabel: UILabel!
    
    //UserInfo
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!


    @IBOutlet weak var claimedImage: UIImageView!
    var bounty: XHERBounty! {
        
        didSet {
            
            //User info
            self.postedByUserLabel.text = bounty.postedByUser?.username
            if let profileImage = bounty.postedByUser?.profileImageUrl {
                userProfileImage.setImageWith(profileImage)
            }
            else {
                userProfileImage.isHidden = true
            }
            
            //Bounty info
            self.bountyNotesLabel.text = "\"\(bounty.bountyNote)\""
            
            //Location info
            self.locationTitleLabel.text = bounty.postedAtLocation.title
            let poi = bounty.postedAtLocation
            locationTitleLabel.text = poi.placeName
            if let poiImage = poi.placeImageURL {
                claimedImage.setImageWith(poiImage)
            }
        }
    }
    
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
        
        self.selectionStyle = .none
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func startSelectedAnimation(completion:@escaping ()->()) {
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25,
                                                       animations: {
                                                        self.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(3 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25,
                                                       animations: {
                                                        self.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25,
                                                       animations: {
                                                        self.customContentView.transform = CGAffineTransform(rotationAngle: -CGFloat(3 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25,
                                                       animations: {
                                                        self.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * (M_PI/180)))
                                    })
        },
                                completion: { (didComplete:Bool) in
                                    completion()
        })
    }
    
    override func prepareForReuse() {
        locationTitleLabel.text = ""
        postedByUserLabel.text = ""
        bountyNotesLabel.text = ""
        claimedImage.image = nil
    }
    
    override func layoutSubviews() {
        cellContentView.frame = bounds
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.height/2
        userProfileImage.layer.borderWidth = 2.0
        userProfileImage.layer.borderColor = UIColor.yellow.cgColor
    }
    
}
