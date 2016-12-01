//
//  XHEREDetailViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHEREDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var detailDesciptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextFeild: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    var cameraViewController : UIViewController?
    var currentBounty : XHERBounty!
    let debugging = true
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setupTableView()
        
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
    
    func setupTableView() {
        
        tableView.isHidden = true;
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "CommentCell")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return tableViewDataBackArray.count
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        return cell
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
        claimController.claimingImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: false) {
            self.present(claimController, animated: true, completion: nil)
        }
    }
    

    
    @IBAction func onCommentClick(_ sender: UIButton) {
        
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
