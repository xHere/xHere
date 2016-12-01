//
//  XHEREDetailViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHEREDetailViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var detailDesciptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    var cameraViewController : UIViewController?
    var currentBounty : XHERBounty!
    let debugging = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
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

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
