//
//  LocationCollectionViewCell.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/30/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class LocationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescription : UILabel!
    
    var location : POI!{
        didSet{
            placeNameLabel.text = location.placeName
            
           placeImageView.image = nil
            
            if location.placeImageURL != nil{
                //print("Final url us \(location.placeImageURL!)")
                placeImageView.setImageWith(location.placeImageURL!)
                
            }
            placeDescription.text = location.placeDescription
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
