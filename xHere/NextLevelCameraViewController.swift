//
//  NextLevelCameraViewController.swift
//  xHere
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class NextLevelCameraViewController: UIViewController, NextLevelDelegate, NextLevelPhotoDelegate {

    
    @IBOutlet weak var previewView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setup()
        // Do any additional setup after loading the view.
        
        
        NextLevel.sharedInstance.delegate = self
//        NextLevel.sharedInstance.videoDelegate = self
        NextLevel.sharedInstance.photoDelegate = self
        
        // modify .videoConfiguration, .audioConfiguration, .photoConfiguration properties
        // Compression, resolution, and maximum recording time options are available
//        NextLevel.sharedInstance.videoConfiguration.maxRecordDuration = CMTimeMakeWithSeconds(5, 600)
        NextLevel.sharedInstance.audioConfiguration.bitRate = 44000
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nextLevel = NextLevel.sharedInstance
        if nextLevel.authorizationStatus(forMediaType: AVMediaTypeVideo) == .authorized &&
            nextLevel.authorizationStatus(forMediaType: AVMediaTypeAudio) == .authorized {
            do {
                try nextLevel.start()
            } catch {
                print("NextLevel, failed to start camera session")
            }
        } else {
            nextLevel.requestAuthorization(forMediaType: AVMediaTypeVideo)
            nextLevel.requestAuthorization(forMediaType: AVMediaTypeAudio)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NextLevel.sharedInstance.stop()
        // …
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func setup() {
//        let screenBounds = UIScreen.main.bounds
//        self.previewView = UIView(frame: screenBounds)
        if let previewView = self.previewView {
//            previewView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            previewView.backgroundColor = UIColor.black
            NextLevel.sharedInstance.previewLayer.frame = previewView.bounds
            previewView.layer.addSublayer(NextLevel.sharedInstance.previewLayer)
//            self.view.addSubview(previewView)
        }
    }
    
    
    // permission
    func nextLevel(_ nextLevel: NextLevel, didUpdateAuthorizationStatus status: NextLevelAuthorizationStatus, forMediaType mediaType: String){}
    
    // configuration
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoConfiguration videoConfiguration: NextLevelVideoConfiguration){}
    func nextLevel(_ nextLevel: NextLevel, didUpdateAudioConfiguration audioConfiguration: NextLevelAudioConfiguration){}
    
    // session
    func nextLevelSessionWillStart(_ nextLevel: NextLevel){}
    func nextLevelSessionDidStart(_ nextLevel: NextLevel){}
    func nextLevelSessionDidStop(_ nextLevel: NextLevel){}
    
    // device, mode, orientation
    func nextLevelDevicePositionWillChange(_ nextLevel: NextLevel){}
    func nextLevelDevicePositionDidChange(_ nextLevel: NextLevel){}
    
    func nextLevelCaptureModeWillChange(_ nextLevel: NextLevel){}
    func nextLevelCaptureModeDidChange(_ nextLevel: NextLevel){}
    
    // orientation
    func nextLevel(_ nextLevel: NextLevel, didChangeDeviceOrientation deviceOrientation: NextLevelDeviceOrientation){}
    
    // aperture
    func nextLevel(_ nextLevel: NextLevel, didChangeCleanAperture cleanAperture: CGRect){}
    
    // focus, exposure, white balance
    func nextLevelWillStartFocus(_ nextLevel: NextLevel){}
    func nextLevelDidStopFocus(_  nextLevel: NextLevel){}
    
    func nextLevelWillChangeExposure(_ nextLevel: NextLevel){}
    func nextLevelDidChangeExposure(_ nextLevel: NextLevel){}
    
    func nextLevelWillChangeWhiteBalance(_ nextLevel: NextLevel){}
    func nextLevelDidChangeWhiteBalance(_ nextLevel: NextLevel){}
    
    // torch, flash
    func nextLevelDidChangeFlashMode(_ nextLevel: NextLevel){}
    func nextLevelDidChangeTorchMode(_ nextLevel: NextLevel){}
    
    func nextLevelFlashActiveChanged(_ nextLevel: NextLevel){}
    func nextLevelTorchActiveChanged(_ nextLevel: NextLevel){}
    
    func nextLevelFlashAndTorchAvailabilityChanged(_ nextLevel: NextLevel){}
    
    // zoom
    func nextLevel(_ nextLevel: NextLevel, didUpdateVideoZoomFactor videoZoomFactor: Float){}
    
    // preview
    func nextLevelWillStartPreview(_ nextLevel: NextLevel){}
    func nextLevelDidStopPreview(_ nextLevel: NextLevel){}
    
    
    func nextLevel(_ nextLevel: NextLevel, willCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration){}
    
    
    func nextLevel(_ nextLevel: NextLevel, didCapturePhotoWithConfiguration photoConfiguration: NextLevelPhotoConfiguration){
        
        print("didCapturePhotoWithConfiguration")

    }
    
    func nextLevel(_ nextLevel: NextLevel, didProcessPhotoCaptureWith photoDict: [String: Any]?, photoConfiguration: NextLevelPhotoConfiguration){
    
        print("didProcessPhotoCaptureWith")
    }
    func nextLevel(_ nextLevel: NextLevel, didProcessRawPhotoCaptureWith photoDict: [String: Any]?, photoConfiguration: NextLevelPhotoConfiguration){}
    
    func nextLevelDidCompletePhotoCapture(_ nextLevel: NextLevel){
        print("nextLevelDidCompletePhotoCapture")

    }

    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        
        NextLevel.sharedInstance.capturePhotoFromVideo()
        
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
