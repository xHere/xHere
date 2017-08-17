//
//  NearByClaimedViewCell.swift
//  xHere
//
//  Created by Developer on 11/17/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

@objc protocol XHERNearByClaimedViewCellDelegate {
    @objc optional func userDidSwipeCollectionViewTo(offset:CGFloat)
    func userDidChoose(claimedBounty:XHERBounty)
}

class XHERNearByClaimedViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    weak var delegate:XHERNearByClaimedViewCellDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backgroundColorView: UIView!
    
    var nearByClaimedArray:[XHERBounty]? {
        
//        get {
//            if let nearByClaimedArray = self.nearByClaimedArray {
//                return nearByClaimedArray
//
//            }
//            else {
//                return nil
//            }
//        }
//        set {
//            if let nearByClaimedArray = nearByClaimedArray {
//                collectionViewDataBackArray = nearByClaimedArray
//                self.collectionView.reloadData()
//            }
//        }
        
        
        didSet {
            if let nearByClaimedArray = nearByClaimedArray {
                
                
                
                let firstTenBounties = nearByClaimedArray[0...nearByClaimedArray.count%10]
                
                collectionViewDataBackArray = Array(firstTenBounties)
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
        
//        let nib = UINib(nibName: "XHERNearByClaimedCollectionCell", bundle: nil)
//        self.collectionView.register(nib, forCellWithReuseIdentifier: "XHERNearByClaimedCollectionCell")
        
        self.collectionView.register(XHERHomeFeedNearByClaimedCollectionCell.self, forCellWithReuseIdentifier: "XHERHomeFeedNearByClaimedCollectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewDataBackArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "XHERHomeFeedNearByClaimedCollectionCell", for: indexPath) as! XHERHomeFeedNearByClaimedCollectionCell
        
        
        if let imageURLString = collectionViewDataBackArray[indexPath.row].mediaArray?[0].mediaData?.url {
            
            
            let imageURL = URL(string: imageURLString)
            
            cell.imageView.setImageWith(imageURL!)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bounty = collectionViewDataBackArray[indexPath.row]
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! XHERNearByClaimedCollectionCell
        
        weak var weakSelf = self
        cell.startSelectedAnimation { (cell:XHERNearByClaimedCollectionCell) in
            weakSelf?.delegate?.userDidChoose(claimedBounty: bounty)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let collectionCell = cell as! XHERHomeFeedNearByClaimedCollectionCell
        collectionCell.imageView.layer.cornerRadius = collectionCell.bounds.size.height/2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.size.height * 0.75
        let cellSize = CGSize(width: width, height: width)
        
        return cellSize
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetPercentIntoSecondPage = scrollView.contentOffset.x / scrollView.bounds.width
        
        delegate?.userDidSwipeCollectionViewTo!(offset: offSetPercentIntoSecondPage)
    }
    
}
