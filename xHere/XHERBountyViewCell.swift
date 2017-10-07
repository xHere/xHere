//
//  XHERHomeFeedViewCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERBountyViewCell: UITableViewCell {
    
    let dateFormatter = DateFormatter()

    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var customContentView: UIView!

    @IBOutlet weak var locationTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var bountyNotesLabel: UILabel!
    @IBOutlet weak var claimITLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    //UserInfo
    @IBOutlet weak var postedByUserLabel: UILabel!
    @IBOutlet weak var userProfileImage: UIImageView!

    //Main Container Image
    @IBOutlet weak var claimedImage: UIImageView!
    
    var viewModel:XHERBountyViewCellModel! {
    
        didSet {
        
            //Location Info
            viewModel.locationTitle.bind { [unowned self] (title) in
                self.locationTitleLabel.text = title
            }
            viewModel.distanceText.bind { [unowned self] (distance) in
                self.distanceLabel.text = distance
            }
            
            //Bounty Info
            viewModel.bountyNotesText.bind { [unowned self] (bountyNote) in
                self.bountyNotesLabel.text = bountyNote
            }
            viewModel.isClaimed.bind { [unowned self] (isClaimed) in
                self.claimITLabel.isHidden = isClaimed
            }
            viewModel.updatedDate.bind { [unowned self] (date) in
                self.updatedDateLabel.text = date
            }
            
            //User Info
            viewModel.posedByUser.bind { [unowned self] (userName) in
                self.postedByUserLabel.text = userName
            }
            viewModel.userProfileImage?.bind { [unowned self] (imageURL) in
                self.userProfileImage.setImageWith(imageURL)
            }
            
            //Bounty Image
            viewModel.claimedImage?.bind { [unowned self] (imageURL) in
                self.claimedImage.setImageWith(imageURL)
            }
        }
        
    }
    
//    var bounty: XHERBounty!
//    {
//
//        didSet {
//            
//            //User info
//            self.postedByUserLabel.text = bounty.postedByUser?.username
//            if let profileImage = bounty.postedByUser?.profileImageUrl {
//                userProfileImage.isHidden = false
//                userProfileImage.setImageWith(profileImage)
//            }
//            else {
//                userProfileImage.isHidden = true
//            }
//            
//
//            
//            //Location info
//            let distance = self.roundToPlaces(value: bounty.postedAtLocation.distanceFromCurrentInMiles, decimalPlaces: 2)
//            self.distanceLabel.text = "\(distance) mi"
//            print("Bonty place name \(bounty.postedAtLocation.placeName)")
//            self.locationTitleLabel.text = bounty.postedAtLocation.placeName
//            
//            
//            //Bounty info
//            self.bountyNotesLabel.text = "\"\(bounty.bountyNote)\""
//            
//          
//            //Updated date info
//            self.updatedDateLabel.text = self.getCurrentDate(updatedDate: bounty.createdAt!)
//            
//           
//            
//            //Check if this bounty has an image aka claimed
//            if let bountyClaimedImageURLStr = bounty.mediaArray?[0].mediaData?.url,
//                let bountyClaimedImageURL = URL(string:bountyClaimedImageURLStr)
//            {
//                claimedImage.setImageWith(bountyClaimedImageURL)
//                
//                //Find Claim it Lable if claimed
//                self.claimITLabel.isHidden = true
//            }
//            else {
//                let poi = bounty.postedAtLocation
//                locationTitleLabel.text = poi.placeName
//                if let poiImage = poi.placeImageURL {
//                    claimedImage.setImageWith(poiImage)
//                }
//                self.claimITLabel.isHidden = false
//            }
//        }
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
        customContentView.layer.cornerRadius = 5
        
        contentView.addSubview(cellContentView)
        
        self.selectionStyle = .none
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func startSelectedAnimation(completion:@escaping (XHERBountyViewCell)->()) {
        self.claimITLabel.textColor = kXHERYellow
        weak var weakSelf = self
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                                                        weakSelf?.claimITLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)

                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                                        weakSelf?.claimITLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })

        },
                                completion: { (didComplete:Bool) in
                                    if let strongSelf = weakSelf {
                                        strongSelf.claimITLabel.textColor = UIColor.white
                                        completion(strongSelf)
                                    }
        })

        
    }
    
    func startDeniedSelectionAnimation(completion:@escaping (XHERBountyViewCell)->()) {
        self.distanceLabel.textColor = UIColor.red
        weak var weakSelf = self
        UIView.animateKeyframes(withDuration: 1.4, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.1,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(3 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.1, relativeDuration: 0.1,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.1,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(rotationAngle: -CGFloat(3 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.1,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(rotationAngle: CGFloat(0 * (M_PI/180)))
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.5,
                                                       animations: {
                                                        weakSelf?.distanceLabel.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.5,
                                                       animations: {
                                                        weakSelf?.distanceLabel.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                    
                                    
        },
                                completion: { (didComplete:Bool) in
                                    if let strongSelf = weakSelf {
                                        
                                        weakSelf?.distanceLabel.textColor = UIColor.white
                                        print("Run COMPLETION")
                                        completion(strongSelf)
                                    }
        })

    }
    
    override func prepareForReuse() {
        claimITLabel.textColor = UIColor.white
        distanceLabel.text = ""
        distanceLabel.textColor = UIColor.white
        locationTitleLabel.text = ""
        postedByUserLabel.text = ""
        bountyNotesLabel.text = ""
        claimedImage.image = UIImage(named: "NoImagePlaceHolder")
        updatedDateLabel.text = ""
    }
    
    override func layoutSubviews() {
        cellContentView.frame = bounds
        userProfileImage.layer.cornerRadius = userProfileImage.bounds.size.height/2
        userProfileImage.layer.borderWidth = 2.0
        userProfileImage.layer.borderColor = UIColor.yellow.cgColor
    }
    
}
