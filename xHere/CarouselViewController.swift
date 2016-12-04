//
//  CarouselViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 12/1/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import iCarousel

class CarouselViewController: UIViewController,iCarouselDataSource, iCarouselDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var carousel: iCarousel!
    var bounties : [XHERBounty]?
    var currentIndex  = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        carousel.type = .coverFlow2
        carousel.delegate = self
        carousel.dataSource = self
        carousel.currentItemIndex  = currentIndex
        carousel.isPagingEnabled = true
        //        setupBackground(currentIndex: currentIndex)
        if(currentIndex == 0){
            intialSetup()
        }
        profileImageView.clipsToBounds = true
//        profileImageView.layer.borderWidth = 1
        profileImageView.layer.masksToBounds = false
//        profileImageView.layer.borderColor = UIColor.black.cgColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
    }
    
    
    public func numberOfItems(in carousel: iCarousel) -> Int {
        if let bounties =  bounties {
            if bounties.count > 0 {
                return bounties.count
            }
            else{
                return 0
            }
        } else {
            return 0
        }
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        var itemView: UIImageView

            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width:  400, height: 400))
            if let bounty = bounties?[index] {
                if let media = bounty.mediaArray?[0]{
                    let url = URL(string: (media.mediaData?.url)!)
                    itemView.setImageWith(url!)
                    itemView.clipsToBounds = true
                    itemView.backgroundColor = UIColor.clear
                }
            }
        
        print(bounties?[index].claimedByUser!.email)
//        self.userNameLabel.text = bounties?[index].claimedByUser?.username!
        return itemView
    }
    
    func intialSetup(){
        userNameLabel.text = bounties?[0].claimedByUser?.firstName
        profileImageView.setImageWith((bounties?[0].claimedByUser?.profileImageUrl)!)
        if let bounty = bounties?[0] {
            if let media = bounty.mediaArray?[0]{
                let url = URL(string: (media.mediaData?.url)!)
                backgroundImageView.setImageWith(url!)
                let blurEffect = UIBlurEffect(style: .light)
                let blurview = UIVisualEffectView(effect: blurEffect)
                blurview.frame = backgroundImageView.bounds
                //        blurview.backgroundColor = UIColor.red
                backgroundImageView.addSubview(blurview)
            }
        }
    }
    
    func setupBackground(currentIndex : Int ){
        let currentView = carousel.currentItemView as! UIImageView
        backgroundImageView.image = currentView.image
        backgroundImageView.subviews.forEach({ $0.removeFromSuperview() })
        let blurEffect = UIBlurEffect(style: .light)
        let blurview = UIVisualEffectView(effect: blurEffect)
        blurview.frame = backgroundImageView.bounds
        backgroundImageView.addSubview(blurview)
        
    }
    
    func carouselCurrentItemIndexDidChange(_ carousel: iCarousel) {
        print(carousel.currentItemIndex)
        var currentIndex = carousel.currentItemIndex
        userNameLabel.text = bounties?[currentIndex].claimedByUser?.firstName
        print(bounties?[0].claimedByUser?.profileImageUrl)
        profileImageView.setImageWith((bounties?[currentIndex].claimedByUser?.profileImageUrl)!)
        setupBackground(currentIndex: currentIndex)
    }
    
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }
    
}
