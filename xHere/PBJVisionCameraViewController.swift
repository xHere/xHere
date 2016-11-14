//
//  CameraViewController.swift
//  xHere
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import PBJVision
class PBJVisionCameraViewController: UIViewController, PBJVisionDelegate {

    
    @IBOutlet weak var previewView: UIView!
    
    @IBOutlet var longPressGesture: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupPreviewLayer()
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        longPressGesture.isEnabled = true
        let vision = PBJVision.sharedInstance()
        
        vision.delegate = self
        vision.cameraMode = .photo
        vision.cameraOrientation = .portrait
        vision.focusMode = .autoFocus
        vision.outputFormat = .square
    }

    
    func setupPreviewLayer() {
        
        let layer = PBJVision.sharedInstance().previewLayer
        
        layer.frame = previewView.bounds
//        layer.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer .addSublayer(layer)
    }
    
    @IBAction func userLongPressed(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            
        
            break
        case .ended:
            PBJVision.sharedInstance().capturePhoto()

        default:
            break
        }
    }
    
//    func vision(_ vision: PBJVision, capturedPhoto photoDict: [AnyHashable : Any]?, error: Error?) {
//        
//        print(error?.localizedDescription)
//        let photo = photoDict?[PBJVisionPhotoImageKey]
//        print(photo.debugDescription)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
