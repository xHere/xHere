//
//  CameraViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice:AVCaptureDevice?
    var currentBounty : XHERBounty!
    @IBOutlet weak var imagePreviewView: UIImageView!
    @IBOutlet weak var postButton: UIButton!
    let testing = false
    var animator: UIDynamicAnimator? = nil
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionLabel.text = currentBounty.bountyNote
        imagePreviewView.isHidden = true
        previewView.backgroundColor = UIColor.black
        cameraButton.backgroundColor = .clear
        cameraButton.layer.cornerRadius = cameraButton.frame.height/2
        cameraButton.layer.borderWidth = 2
        cameraButton.layer.borderColor = UIColor.white.cgColor
        postButton.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !testing {
            setupCameraSession()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !testing {
            videoPreviewLayer!.frame = previewView.bounds
        }
    }
    
    func setupCameraSession(){
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
            if error == nil && session!.canAddInput(input) {
                session!.addInput(input)
                
                // The remainder of the session setup will go here...
                stillImageOutput = AVCaptureStillImageOutput()
                stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
                
                if session!.canAddOutput(stillImageOutput) {
                    session!.addOutput(stillImageOutput)
                    // ...
                    // Configure the Live Preview here...
                    videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
                    videoPreviewLayer!.videoGravity = AVLayerVideoGravityResizeAspect
                    videoPreviewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                    previewView.layer.addSublayer(videoPreviewLayer!)
                    session!.startRunning()
                }
                
            }
            
        } catch let error1 as NSError {
            error = error1
            input = nil
            print(error!.localizedDescription)
        }
    }
    
    
    var pictureTaken = false
    @IBAction func didTakePhoto(_ sender: AnyObject) {
        if testing {
            
            //                imagePreviewView.isHidden = false
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            present(picker, animated: true, completion: nil)
            //                imagePreviewView.image = UIImage(named: "testImage")
            
            pictureTaken = !pictureTaken
        }
        else {
            if pictureTaken == false {
                self.imagePreviewView.isHidden = true
                //                let settings = AVCapturePhotoSettings()
                
                if let videoConnection = stillImageOutput?.connection(withMediaType: AVMediaTypeVideo) {
                    stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer: CMSampleBuffer?, error: Error?) in
                        if sampleBuffer! != nil {
                            let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                            let dataProvider = CGDataProvider(data: imageData as! CFData)
                            let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                            let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                            self.imagePreviewView.image = image
                            self.imagePreviewView.isHidden = false
                            self.postButton.isHidden = false
                        }
                    })
                }
            }
            else {
                imagePreviewView.isHidden = true
                postButton.isHidden = true
            }
            pictureTaken = !pictureTaken
        }
        postButton.isHidden = !pictureTaken
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let size = CGSize(width: 400, height: 400)
        let claimedImage = resize(image: (info[UIImagePickerControllerOriginalImage] as? UIImage)!, newSize: size)
        self.imagePreviewView.image = claimedImage
        self.imagePreviewView.isHidden = false
        self.dismiss(animated: false) {
            self.postButton.isHidden = false
            
        }
    }
    
    @IBAction func cancelCamera(_ sender: UIButton) {
        
        dismiss(animated: true) {
            if !self.testing {
                
                let currentCameraInput: AVCaptureInput = self.session!.inputs[0] as! AVCaptureInput
                self.session?.removeInput(currentCameraInput)
            }
        }
    }
    
    @IBAction func switchCamera(_ sender: AnyObject) {
        let currentCameraInput: AVCaptureInput = session!.inputs[0] as! AVCaptureInput
        session?.removeInput(currentCameraInput)
        
        let newCamera: AVCaptureDevice?
        if(captureDevice!.position == AVCaptureDevicePosition.back){
            
            newCamera = self.cameraWithPosition(position: AVCaptureDevicePosition.front)
        } else {
            
            newCamera = self.cameraWithPosition(position: AVCaptureDevicePosition.back)
        }
        var error: NSError?
        var newVideoInput: AVCaptureDeviceInput!
        do {
            let newVideoInput = try AVCaptureDeviceInput(device: newCamera!)
            if(newVideoInput != nil) {
                session?.addInput(newVideoInput)
            } else {
                
            }
            
            session?.commitConfiguration()
            captureDevice! = newCamera!
        } catch let error1 as NSError {
            error = error1
            newVideoInput = nil
            print(error!.localizedDescription)
            
        }
        
    }
    
    func cameraWithPosition(position: AVCaptureDevicePosition) -> AVCaptureDevice {
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if((device as AnyObject).position == position){
                return device as! AVCaptureDevice
            }
        }
        return AVCaptureDevice()
    }
    
    @IBAction func postPicture(_ sender: AnyObject) {
        let size = CGSize(width: 400, height: 400)
        let image = self.resize(image: imagePreviewView.image!, newSize: size)
        XHERServer.sharedInstance.claimBounty(user: PFUser.current() as! User, objectId: (currentBounty?.objectId!)!, image: image,
                                              success: { (bounty:XHERBounty, tokentAmount:Int) in
                                                print("Bounty claimed Successfully")
                                                self.addCoin(location: CGRect(x: 150, y: self.bottomView.frame.origin.y, width: self.view.frame.width * 0.16, height: self.view.frame.height * 0.16))
                                                self.startAnimation()
            },
                                              faliure: { (error:Error) in
                                                
        })
        
    }
    let gravity = UIGravityBehavior()
    func startAnimation(){
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity.gravityDirection = CGVector(dx: 0, dy: -1.0)
        gravity.magnitude = 0.6
        animator?.addBehavior(gravity)
        startFlipping()
        cameraButton.isHidden = true
        gravity.addItem(self.coin!)
        
        gravity.action = {
           
            if((self.coin?.frame.origin.y)! < CGFloat(-100)){
                print(self.coin?.frame.origin.y)
                self.animator?.removeAllBehaviors()
                self.stopFlipping = true
                let animationView = AnimationViewController()
                animationView.claimedImage = self.imagePreviewView.image
                self.coin?.isHidden = true
                self.present(animationView, animated: true, completion: nil)
                
            }
            
        }
    }
    
    
    var coin : UIImageView?
    func addCoin(location: CGRect) {
        self.view.layoutIfNeeded()
        coin = UIImageView(frame: location)
        coin?.backgroundColor = UIColor.red
        coin?.image = UIImage(named: "coinFront")
        coin?.layer.masksToBounds = true
        coin?.clipsToBounds = true
        coin?.backgroundColor = UIColor.clear
        self.view.addSubview(coin!)
    }
    
    var green = true
    var stopFlipping = false
    func startFlipping(){
        UIView.transition(with: self.coin!, duration: 0.2, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            if self.green {
                
                self.coin?.image = UIImage(named: "coinBack")
            }
            else {
                
                self.coin?.image = UIImage(named: "coinFront")
            }
            self.green = !self.green
        }) { (finsihed: Bool) in
            print(finsihed)
            if self.stopFlipping  == false{
                self.startFlipping()
            }
        }
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
}


