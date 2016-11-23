//
//  NearByClaimedCollectionCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERNearByClaimedCollectionCell: UICollectionViewCell {


    @IBOutlet weak var circleClippingView: CircleClippingView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
////        imageView.layer.borderColor = UIColor.green.cgColor
////        imageView.layer.borderWidth = 5
//        imageView.layer.cornerRadius = imageView.bounds.width/2
    }

}
