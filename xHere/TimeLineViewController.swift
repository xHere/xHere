//
//  TimeLineViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//


import UIKit
import Parse

class TimeLineViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tempLogout(_ sender: UIButton) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDidLogOut"), object: nil)
            }
        }
    }
}
