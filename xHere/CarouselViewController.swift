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
    
    @IBOutlet weak var carousel: iCarousel!
    var bounties : [XHERBounty]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carousel.type = .coverFlow2
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
            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width:  400, height: 400))
            if let bounty = bounties?[index] {
                if let media = bounty.mediaArray?[0]{
                    let url = URL(string: (media.mediaData?.url)!)
                    itemView.setImageWith(url!)
                    itemView.clipsToBounds = true
                }
                itemView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            }
            label = UILabel(frame: itemView.bounds)
            label.backgroundColor = .clear
            label.textAlignment = .center
            label.contentMode = .bottom
            label.font = label.font.withSize(10)
        
            label.tag = 1
            itemView.addSubview(label)
        }

//        label.text = "@\()"
        
        return itemView
    }
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }

}
