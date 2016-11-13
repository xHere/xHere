//
//  xHERProfileViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHERProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let logOutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(sender:)))
        self.navigationItem.leftBarButtonItem = logOutButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func logOut(sender:UIBarButtonItem) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDidLogOut"), object: nil)
            }
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
