//
//  LocationCollectionViewCell.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/30/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
let placeholderImage = UIImage(named: "NoImagePlaceHolder")
class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescription : UILabel!
    
    var location : POI!{
        didSet{
            placeNameLabel.text = location.placeName
            
           placeImageView.image = nil
            
            if location.placeImageURL != nil{
                
                placeImageView.setImageWith(location.placeImageURL!, placeholderImage: placeholderImage)
                
            }
            placeDescription.text = location.placeDescription
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        placeImageView.layer.shadowColor = UIColor.lightGray.cgColor
        placeImageView.layer.shadowOpacity = 1
        placeImageView.layer.shadowOffset = CGSize(width: 1.0, height: 2.0)
        placeImageView.layer.shadowRadius = 20
    }

}
