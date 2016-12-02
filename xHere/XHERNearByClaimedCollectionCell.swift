//
//  NearByClaimedCollectionCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERNearByClaimedCollectionCell: UICollectionViewCell {


    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var claimedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
}
