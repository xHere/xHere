//
//  NearByClaimedCollectionCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERNearByClaimedCollectionCell: UICollectionViewCell {


    @IBOutlet var customContentView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var claimedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "XHERNearByClaimedCollectionCell", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        customContentView.frame = self.contentView.bounds
        contentView.addSubview(customContentView)
    }
        
}
