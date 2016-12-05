//
//  ClaimViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/26/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class ClaimViewController: UIViewController {

    @IBOutlet weak var preiviewImage: UIImageView!
    @IBOutlet weak var postItbutton: UIButton!
    var claimingImage : UIImage!
    var bounty: XHERBounty?
    override func viewDidLoad() {
        super.viewDidLoad()
        if (claimingImage) != nil {
            preiviewImage.image = claimingImage
        }
    }

    
    @IBAction func claimBounty(_ sender: AnyObject) {
//        XHERServer.sharedInstance.claimBounty(user: PFUser.current() as! User, objectId: (bounty?.objectId!)!, image: preiviewImage.image!, success:(bounty:XHERBounty, tokentAmount:Int) {
//            print("Bounty claimed Successfully")
//            let homeTabBarVC = XHERHomeTabBarViewController()
//            self.present(homeTabBarVC, animated: true, completion: nil)
//        }) { (error :Error) in
//            
//        }
        
        let animationView = AnimationViewController()
        self.present(animationView, animated: true, completion: nil)
        
//        XHERServer.sharedInstance.claimBounty(user: PFUser.current() as! User, objectId: (bounty?.objectId!)!, image: preiviewImage.image!,
//              success: { (bounty:XHERBounty, tokentAmount:Int) in
//                print("Bounty claimed Successfully")
//                let homeTabBarVC = XHERHomeTabBarViewController()
//                self.present(homeTabBarVC, animated: true, completion: nil)
//        },
//              faliure: { (error:Error) in
//                
//        })
        
    }

}
