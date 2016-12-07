//
//  XHEREDetailViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHEREDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var searchDistanceInMiles = 0.0

    
    enum DetailViewControllerMode: String {
        case posting = "postingMode",
        claiming = "claimingMode",
        browsing = "browsingMode"
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Posting related
    @IBOutlet weak var postBountyPanel: UIView!
    @IBOutlet weak var bountyNoteTextView: UITextView!
    var location:POI?
    @IBOutlet weak var postUserProfileImageView: UIImageView!
    @IBOutlet weak var postUserNameLabel: UILabel!
    @IBOutlet weak var postBountyButtonPanel: UIView!
    @IBOutlet weak var bountyNote: UILabel!
    @IBOutlet weak var bountyNoteBackgroundView: UIView!
    @IBOutlet weak var userTokenCountLabel: UILabel!
    @IBOutlet weak var userTokenResultCount: UILabel!
  
    //Claiming related
    @IBOutlet weak var claimedBountyImageView: UIImageView!
    @IBOutlet weak var claimUserProfileImage: UIImageView!
    @IBOutlet weak var claimUserNameLabel: UILabel!
    @IBOutlet weak var claimBountyPanel: UIView!
    @IBOutlet weak var claimBountyButton: UIButton!
    @IBOutlet weak var claimBountyButtonPanel: UIView!
    @IBOutlet weak var claimBountyCameraButtonView: UIView!
   
    @IBOutlet weak var previousClaimedNearbyPanel: UIView!
    
    var viewControllerMode:DetailViewControllerMode?
    var currentBounty : XHERBounty!
    var nearbyBounties : [XHERBounty]?

    
    let debugging = false
    var server = XHERServer.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        weak var weakSelf = self
        getNearByClaimedBounties { 
            if let nearbyBounties = weakSelf?.nearbyBounties {
                if nearbyBounties.count == 0 {
                    weakSelf?.previousClaimedNearbyPanel.isHidden = true
                    self.view.setNeedsLayout()
                }
            }
        }
        
        
        let notificationName = Notification.Name("CompletedClaiming")
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteClaiming(sender:)), name: notificationName, object: nil)
    }
    
    func didCompleteClaiming(sender:Any) {
        
        let notification = sender as! Notification
        
        
        let claimedImage = notification.userInfo?["claimedImage"]!
        
        self.claimBountyCameraButtonView.isHidden = true
        self.claimedBountyImageView.alpha = 0
        self.claimedBountyImageView.image = claimedImage as! UIImage?
        
        
        self.dismiss(animated: true, completion: {
            weak var weakSelf = self
            UIView.animate(withDuration: 5,
                           animations: {
                            weakSelf?.claimedBountyImageView.alpha = 1
            },
                           completion: { (didComplete:Bool) in
                            
            })
        })

        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("      ImageViewHeight at appear = \(self.postUserProfileImageView.frame.size.height)")

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
        self.scrollView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
        
        //Some View config
        self.postUserProfileImageView.layer.cornerRadius = self.postUserProfileImageView.frame.size.height/2
        print("     ImageViewHeight = \(self.postUserProfileImageView.frame.size.height)")
        self.postUserProfileImageView.layer.borderColor = kXHEROrange.cgColor
        self.postUserProfileImageView.layer.borderWidth = 2
        
        self.claimUserProfileImage.layer.cornerRadius = self.claimUserProfileImage.frame.size.height/2
        self.claimUserProfileImage.layer.borderWidth = 2
        self.claimUserProfileImage.layer.borderColor = kXHERYellow.cgColor
        
        self.claimedBountyImageView.layer.cornerRadius = 20
        //self.claimedBountyImageView.bounds.size.height/10
        self.claimBountyCameraButtonView.layer.cornerRadius = 20
        self.bountyNoteBackgroundView.layer.cornerRadius = 20
        //self.bountyNote.bounds.height/10

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }

    // MARK: - View Mode Setup
    func setupView(){

        self.navigationController?.navigationBar.isHidden = false

        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backButtonOrange"), style: .plain, target: self, action: #selector(touchOnBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = kXHEROrange
        

        
        
        
        if viewControllerMode! == .posting {
            setupPostingMode()
        }
        else if viewControllerMode! == .claiming {
            setupClaimingMode()
        }
        else if viewControllerMode! == .browsing {
            setupBrowsingMode()
        }
        
        //Location info
        self.placeNameLabel.text = location?.placeName
        if let placeImageURL = location?.placeImageURL {
            self.mainImageView.setImageWith(placeImageURL)
        }
        self.title = location?.placeName
    }
    
    func setupPostingMode() {
        //User Info
        let currentUser = PFUser.current() as! User
        postUserNameLabel.text = currentUser.firstName
        if let imageURL = currentUser.profileImageUrl {
            postUserProfileImageView.setImageWith(imageURL)
        }
        
        let tokenCount = currentUser.tokens
        self.userTokenCountLabel.text = "\(tokenCount) - 1x"
        self.userTokenResultCount.text = "\(tokenCount-1)"
        
        //Set TextView's design
        self.bountyNoteTextView.placeholder = "What would you like to know?"
        self.bountyNoteTextView.placeholderColor = UIColor.lightGray
        self.bountyNoteTextView.layer.cornerRadius = 10
        self.bountyNoteTextView.layer.borderColor = kXHEROrange.cgColor
        self.bountyNoteTextView.layer.borderWidth = 2
        
        //Hide Claim related elements
        self.claimBountyPanel.isHidden = true
        self.claimBountyButtonPanel.isHidden = true
        self.claimBountyPanel.isHidden = true
    }
    
    func setupClaimingMode() {
        
        if let currentBounty = currentBounty {

            self.setupPostingMode()
            
            self.claimBountyPanel.isHidden = false
            self.claimBountyButtonPanel.isHidden = true
            self.claimBountyCameraButtonView.isHidden = false
            
            //Post User View
            let postUser = currentBounty.postedByUser
            if let imageURL = postUser?.profileImageUrl {
                self.postUserProfileImageView.setImageWith(imageURL)
            }
            else {
                self.postUserProfileImageView.isHidden = true
            }
            
            if let postUserName = postUser?.firstName {
                postUserNameLabel.text = postUserName
            }
            else {
                postUserNameLabel.isHidden = true
            }
            
            //Claim User View
            let currentUser = PFUser.current() as! User
            if let imageURL = currentUser.profileImageUrl {
                self.claimUserProfileImage.setImageWith(imageURL)
            }
            claimUserNameLabel.text = currentUser.firstName
            
            //Set the location of this class to the bounty location
            self.location = currentBounty.postedAtLocation
            
            //Hide the post button
            self.postBountyButtonPanel.isHidden = true
            
            //Bounty Note
            bountyNote.isHidden = false
            bountyNote.text = "\"\(currentBounty.bountyNote)\""
            self.bountyNoteTextView.isHidden = true
        }
    }
    
    func setupBrowsingMode() {
        
        setupClaimingMode()
        
        //Hide all buttons
        postBountyButtonPanel.isHidden = true
        claimBountyButtonPanel.isHidden = true
        
        if currentBounty.isClaimed {
            //If there is claimed bounty image show that or show poi image
            if let bountyClaimedImageURLStr = currentBounty.mediaArray?[0].mediaData?.url,
                let bountyClaimedImageURL = URL(string:bountyClaimedImageURLStr)
            {
                claimedBountyImageView.setImageWith(bountyClaimedImageURL)
            }
            self.claimBountyCameraButtonView.isHidden = true
        }
        else {
            self.claimBountyPanel.isHidden = true
        }
        
    }

    func touchOnBack() {
        self.navigationController?.popViewController(animated: true)
    }

    // MARK: - Post Bounty
    @IBAction func touchOnPost(_ sender: UIButton) {
        
        let user = PFUser.current() as! User
        
        guard let location = location
            else {
                return
            }

        weak var weakSelf = self
        server.postBountyBy(user: user, withNote: bountyNoteTextView.text!, atPOI: location, withTokenValue: 1, success: {
            print("Bounty posted successfully")
            

            UIView.animate(withDuration: 4,
                   animations: {
                    weakSelf?.bountyNoteTextView.backgroundColor = kXHEROrange
            },
                   completion: { (didComplete:Bool) in
                        _ = self.navigationController?.popToRootViewController(animated: true)
            })
        }) {
            print("Cant post bounty")
        }
    }
    

    @IBAction func tapOnCameraButtonView(_ sender: UITapGestureRecognizer) {
    
        
        if sender.state == .began {
            
            weak var weakSelf = self
            UIView.animateKeyframes(withDuration: 0.2, delay: 0, options: [],
                    animations: {
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2,
                               animations: {
                                weakSelf?.claimBountyCameraButtonView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
                        })


            },
                    completion: { (didComplete:Bool) in
                        
            })
            
        }
        else if sender.state == .ended {
            
            weak var weakSelf = self
            UIView.animateKeyframes(withDuration: 2, delay: 0, options: [],
                    animations: {

//                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5,
//                                           animations: {
//                                            weakSelf?.claimBountyCameraButtonView.transform = CGAffineTransform(scaleX: 1.02, y: 1.02)
//                        })
                        UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 2,
                                           animations: {
                                            weakSelf?.claimBountyCameraButtonView.transform = CGAffineTransform(scaleX: 100, y: 100)
                        })
                        
//                        UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5,
//                               animations: {
//                                weakSelf?.claimBountyCameraButtonView.transform = CGAffineTransform(scaleX: 1, y: 1)
//                        })
                        
            },
                    completion: { (didComplete:Bool) in
                        weakSelf?.claimBountyCameraButtonView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
            self.startClaiming()
        }
        
    }
    // MARK: - ImagePicker Activate & Delegates
    @IBAction func initClaim(_ sender: UIButton) {
        self.startClaiming()
    }
    
    func startClaiming() {
        if(debugging){
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
        }
        else
        {
            let cameraViewController = CameraViewController(nibName: "CameraViewController", bundle: nil)
            cameraViewController.currentBounty = self.currentBounty
            self.present(cameraViewController, animated: false, completion: nil)
        }
    }
    
    //Debugging Image picker return with Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let size = CGSize(width: 400, height: 400)
        let claimedImage = resize(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, newSize: size)
        
        let claimController = ClaimViewController()
        claimController.bounty = self.currentBounty
        claimController.claimingImage =  claimedImage
        
        
        self.dismiss(animated: false) {
            self.claimedBountyImageView.alpha = 0.0
            self.claimedBountyImageView.image = claimedImage
            
            weak var weakSelf = self
            UIView.animate(withDuration: 1.0,
                           animations: {
                            weakSelf?.claimedBountyImageView.alpha = 1.0
                },
                           completion: { (didComplete:Bool) in
                                self.present(claimController, animated: true, completion: nil)

            })

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
    
}


extension XHEREDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    // MARK: - API call and delegates methods for NearByClaimedBounties CollectionView
    func getNearByClaimedBounties(success:@escaping ()->()){
        
        if let geoPoint = location?.geoPoint {
            server.fetchClaimedBountyNear(location: geoPoint, withInMiles: searchDistanceInMiles, success: { (bounties : [XHERBounty]?) in
                if let bounties = bounties {
                    if (bounties.count) > 0 {
                        self.nearbyBounties = bounties
                        self.setUpCollectionView()
                    }
                }
                else {
                    self.nearbyBounties = []
                }
                success()
            }) { (error: Error?) in
                print(error?.localizedDescription)
            }
        }
    }
    
    func setUpCollectionView(){
//        let nib = UINib(nibName: "ClaimedBountyCell", bundle: nil)
//        collectionView.register(nib, forCellWithReuseIdentifier: "ClaimedBountyCell")
        collectionView.register(XHERNearByClaimedCollectionCell.self, forCellWithReuseIdentifier: "XHERNearByClaimedCollectionCell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let carouselViewController = CarouselViewController(nibName: "CarouselViewController", bundle: nil)
        carouselViewController.bounties = nearbyBounties!
        carouselViewController.currentIndex = indexPath.row
        
        let cell = collectionView.cellForItem(at: indexPath) as! XHERNearByClaimedCollectionCell
        
        cell.startSelectedAnimation { (cell:XHERNearByClaimedCollectionCell) in
            self.navigationController?.pushViewController(carouselViewController, animated: true)
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = collectionView.bounds.size.height - 20
        
        let cellSize = CGSize(width: height, height: height)
        
        return cellSize	
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let collectionCell = cell as! XHERNearByClaimedCollectionCell
        collectionCell.imageView.layer.cornerRadius = collectionCell.bounds.size.height/2
    }
}
