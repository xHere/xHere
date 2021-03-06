//
//  ContentViewCell.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class ContentViewCell: UITableViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var authorScreenName: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentTextLabel: UILabel!
    
    
    //DataSource
    var content:Content! {
        didSet {
            authorScreenName.text = content.user.screenName
            contentTextLabel.text = content.text
            
            
            /* Other properties to map
            likeButton.isSelected = content.hasLiked
            
            if let contentImage = content.mediaObject?.mediaData {
                contentImageView.image = contentImage
            }
            */
            
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
