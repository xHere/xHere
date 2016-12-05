//
//  XHERHomeFeedHeaderView.swift
//  xHere
//
//  Created by Developer on 12/4/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERHomeFeedHeaderView: UITableViewHeaderFooterView {

    
    @IBOutlet var customContentView: UIView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubviews()
    }
    
    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "XHERHomeFeedHeaderView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        customContentView.frame = bounds
        contentView.addSubview(customContentView)
    }

}
