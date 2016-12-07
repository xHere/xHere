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
    
    func startSelectedAnimation(completion:@escaping (XHERNearByClaimedCollectionCell)->()) {
        weak var weakSelf = self
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: [],
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                                                        
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                                                       animations: {
                                                        weakSelf?.customContentView.transform = CGAffineTransform(scaleX: 1, y: 1)
                                    })
                                    
        },
                                completion: { (didComplete:Bool) in
                                    if let strongSelf = weakSelf {
                                        completion(strongSelf)
                                    }
        })
        
        
    }

}
