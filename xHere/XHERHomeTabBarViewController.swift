//
//  HomeTabBarViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHERHomeTabBarViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var contentView: UIView!
    
    var homeFeedNavi:UINavigationController!
    var homeFeedViewController:UIViewController!
    
    var discoveryNavi:UINavigationController!
    var discoverViewController:UIViewController!
    
    var postContentNavi:UINavigationController?
    var postContentViewController:UIViewController?
    
    var profileNavi:UINavigationController!
    var profileViewController:UIViewController!
    
    let debugging = true
    
    var contentVC:UIViewController! {
        didSet {
            if (oldValue != nil) {
                oldValue.willMove(toParentViewController: nil)
                oldValue.view.removeFromSuperview()
                oldValue.removeFromParentViewController()
            }
            self.addChildViewController(contentVC)
            contentVC.willMove(toParentViewController: self)
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
        
        discoverViewController = XHERDiscoveryViewController()
        discoveryNavi = UINavigationController(rootViewController: discoverViewController)
        
        profileViewController = XHERProfileViewController()
        profileNavi = UINavigationController(rootViewController: profileViewController)
        
        self.contentVC = homeFeedNavi
    }
    
    // MARK: - Tab Bar Button Actions
    @IBAction func touchOnHome(_ sender: UIButton) {
        self.contentVC = homeFeedNavi
    }
    
    
    @IBAction func touchOnDiscover(_ sender: UIButton) {
        self.contentVC = discoveryNavi
    }
    
    @IBAction func touchOnCamera(_ sender: UIButton) {
//                postContentViewController = FusumaCameraViewController()
        let picker = UIImagePickerController()
        picker.delegate = self
//        picker.mediaTypes = [kUTTypeMovie as NSString as String]
        if(debugging){
            picker.sourceType = .photoLibrary
        }
        else
        {
            picker.sourceType = .camera
        }
        present(picker, animated: true, completion: nil)
        
      //  postContentViewController = CameraViewController()
        //self.present(postContentViewController!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let postContentVc = FusumaCameraViewController()
        postContentVc.userCreatedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        dismiss(animated: false) {
            self.present(postContentVc, animated: true, completion: nil)
        }
    }

    
    @IBAction func touchOnProfile(_ sender: UIButton) {
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
