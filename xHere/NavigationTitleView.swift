//
//  NavigationTitleView.swift
//  xHere
//
//  Created by Developer on 12/7/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class NavigationTitleView: UIView {

    @IBOutlet var contentView: UIView!

    @IBOutlet weak var textLabel: UILabel!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initSubviews()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubviews()

    }

    
    func initSubviews() {
        let nib = UINib(nibName: "NavigationTitleView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        
        self.addSubview(contentView)
    }


}
