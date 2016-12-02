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
    
    var items: [Int] = [1,2,3,4,5]
    @IBOutlet weak var carousel: iCarousel!
    var bounties : [XHERBounty]?
    override func awakeFromNib() {
        super.awakeFromNib()
        for i in 0 ... 99 {
            items.append(i)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .linear
        carousel.delegate = self
        carousel.dataSource = self
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
        var label: UILabel
        var itemView: UIImageView
        
        if let view = view as? UIImageView {
            itemView = view
            label = itemView.viewWithTag(1) as! UILabel
        } else {
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
            if let bounty = bounties?[index] {
                if let media = bounty.mediaArray?[0]{
                    let url = URL(string: (media.mediaData?.url)!)
                    itemView.setImageWith(url!)
                    itemView.clipsToBounds = true
                }
                
            }
        
            itemView.contentMode = .center
//            label = UILabel(frame: itemView.bounds)
//            label.backgroundColor = .clear
//            label.textAlignment = .center
//            label.font = label.font.withSize(10)
//            label.tag = 1
//            itemView.addSubview(label)
        }

//        label.text = "@\(bounties?[index].claimedByUser!)"
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

}
