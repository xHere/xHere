//
//  XHEREDetailViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHEREDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var searchDistanceInMiles = 100.0
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var detailDesciptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var cameraViewController : UIViewController?
    var currentBounty : XHERBounty!
    let debugging = true
    var server = XHERServer.sharedInstance
    var nearbyBounties : [XHERBounty]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getNearByClaimedBounties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupView(){
        if let currentBounty = currentBounty {
//            placeNameLabel.text = currentBounty.postedAtLocation.placeName
            detailDesciptionLabel.text = currentBounty.bountyNote
            usernameLabel.text = currentBounty.postedByUser?.screenName
            let postedLocation = currentBounty.postedAtLocation
            if let imageUrl = postedLocation.placeImageURL {
                placeImageView.setImageWith(imageUrl)
            }
            
        }
    }
    
    
    func getNearByClaimedBounties(){
        server.fetchClaimedBountyNear(location: currentBounty.postedAtLocation.geoPoint!, withInMiles: searchDistanceInMiles, success: { (bounties : [XHERBounty]?) in
            if (bounties?.count)! > 0 {
                self.nearbyBounties = bounties
                self.setUpCollectionView()
            }
            else
            {
                self.nearbyBounties = []
            }
        }) { (error: Error?) in
                print(error?.localizedDescription)
        }
    }
    
    func setUpCollectionView(){
        let nib = UINib(nibName: "XHERNearByClaimedCollectionCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "XHERNearByClaimedCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func initClaim(_ sender: UIButton) {
        
        if(debugging){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            
        }
        else
        {
            cameraViewController = CameraViewController()
            self.present(cameraViewController!, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let claimController = ClaimViewController()
        claimController.bounty = currentBounty
        let size = CGSize(width: 300, height: 300)
        claimController.claimingImage =  resize(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, newSize: size)
        dismiss(animated: false) {
            self.present(claimController, animated: true, completion: nil)
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension XHEREDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "XHERNearByClaimedCollectionCell", for: indexPath) as! XHERNearByClaimedCollectionCell
        
        if let imageURLString = nearbyBounties?[indexPath.row].mediaArray?[0].mediaData?.url {
            
            
            let imageURL = URL(string: imageURLString)
            
            cell.imageView.setImageWith(imageURL!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.nearbyBounties?.count)! > 0 {
            return (nearbyBounties?.count)!
        }
        else {
            return 0
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellSize = CGSize(width: 100, height: 100)
        
        return cellSize	
    }
}
