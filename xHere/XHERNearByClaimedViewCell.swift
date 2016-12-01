//
//  NearByClaimedViewCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERNearByClaimedViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var nearByClaimedArray:[XHERBounty]? {

        didSet {
            if let nearByClaimedArray = nearByClaimedArray {
                collectionViewDataBackArray = nearByClaimedArray
                self.collectionView.reloadData()
            }
        }
    }
    
    var collectionViewDataBackArray = [XHERBounty]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupCollectionView() {
        
        let nib = UINib(nibName: "XHERNearByClaimedCollectionCell", bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: "XHERNearByClaimedCollectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewDataBackArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "XHERNearByClaimedCollectionCell", for: indexPath) as! XHERNearByClaimedCollectionCell
        
        
        if let imageURLString = collectionViewDataBackArray[indexPath.row].mediaArray?[0].mediaData?.url {
            
            
            let imageURL = URL(string: imageURLString)
            
            cell.imageView.setImageWith(imageURL!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let collectionCell = cell as! XHERNearByClaimedCollectionCell
            collectionCell.imageView.layer.cornerRadius = collectionCell.bounds.size.height/2
        
        print("COLLECTIONCELL HEIGHT = \(collectionCell.bounds.height)")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: collectionView.bounds.size.height, height: collectionView.bounds.size.height)
        
        return cellSize
    }
    
}
