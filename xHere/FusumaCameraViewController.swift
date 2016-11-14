//
//  FusumaCameraViewController.swift
//  xHere
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Fusuma

class FusumaCameraViewController: UIViewController, FusumaDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func touchOnCameraButton(_ sender: Any) {
        
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = true // If you want to let the users allow to use video.
        self.present(fusuma, animated: true, completion: nil)
        
    }
    
    
    // Return the image which is selected from camera roll or is taken via the camera.
    func fusumaImageSelected(_ image: UIImage) {
        
        print("Image selected")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    public func fusumaClosed() {
        
    }
    

    
    // MARK: - Navigation
     @IBAction func touchOnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 

}
