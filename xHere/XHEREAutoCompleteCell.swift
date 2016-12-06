//
//  XHEREAutoCompleteCell.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/29/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHEREAutoCompleteCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    var autoComplete : POI!{
        didSet{
            locationNameLabel.text = autoComplete.placeDescription
            
           
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        self.layer.borderWidth = 0.5
        self.clipsToBounds = true

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
