//
//  HomeTabBarViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHERHomeTabBarViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var discoveryButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var homeFeedNavi:UINavigationController!
    var homeFeedViewController:UIViewController!
    
    var discoveryNavi:UINavigationController!
    var discoverViewController:UIViewController!
    
    var postContentNavi:UINavigationController?
    var postContentViewController:UIViewController?
    
    var profileNavi:UINavigationController!
    var profileViewController:UIViewController!
    
    
    
    var contentVC:UIViewController! {
        didSet {
            if (oldValue != nil) {
                oldValue.willMove(toParentViewController: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParentViewController()
            }
            self.addChildViewController(contentVC)
            contentVC.willMove(toParentViewController: self)
            contentVC.view.frame = contentView.bounds
            contentView.addSubview(contentVC.view)
            contentVC.didMove(toParentViewController: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupContainedControllers()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupContainedControllers() {
        homeFeedViewController = XHERHomeFeedViewController()
        homeFeedNavi = UINavigationController(rootViewController: homeFeedViewController)
        homeFeedNavi.navigationBar.barTintColor = kXHERYellow

        discoverViewController = XHERDiscoveryViewController()
        discoveryNavi = UINavigationController(rootViewController: discoverViewController)
        discoveryNavi.navigationBar.barTintColor = kXHERYellow

        profileViewController = XHEREProfileViewController()
        profileNavi = UINavigationController(rootViewController: profileViewController)
        profileNavi.navigationBar.barTintColor = kXHERYellow

        self.contentVC = homeFeedNavi
    }
    
    // MARK: - Tab Bar Button Actions
    @IBAction func touchOnHome(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        discoveryButton.isSelected = false
        profileButton.isSelected = false
        self.contentVC = homeFeedNavi
    }
    
    
    @IBAction func touchOnDiscover(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        homeButton.isSelected = false
        profileButton.isSelected = false
        self.contentVC = discoveryNavi
        
    }
    
       
    @IBAction func touchOnProfile(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        homeButton.isSelected = false
        discoveryButton.isSelected = false
        self.contentVC = profileNavi
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
