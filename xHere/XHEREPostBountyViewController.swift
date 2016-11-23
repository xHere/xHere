//
//  XHEREPostBountyViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
class XHEREPostBountyViewController: UIViewController {
    
    var location : POI?

    @IBOutlet weak var bountyDescTextFeild: UITextField!
    @IBOutlet weak var placeimageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    let server = XHERServer.sharedInstance
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostBounty(_ sender: Any) {
        let user = PFUser.current() as! User
        server.postBountyBy(user: user, withNote: bountyDescTextFeild.text!, atPOI: location!, withTokenValue: 1, success: {
            print("Bounty posted successfully")
            _ = self.navigationController?.popToRootViewController(animated: true)
           
        }) { 
            print("Cant post bounty")
        }
        
    }
    func setUpView(){
        
        placeNameLabel.text = location?.placeName
        placeimageView.setImageWith((location?.placeImageURL)!)
        imageViewHeightConstraint.constant = self.view.frame.height*0.3
        
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
