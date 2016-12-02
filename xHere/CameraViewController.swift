//
//  CameraViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    var session: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice:AVCaptureDevice?
    var currentBounty : XHERBounty!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCameraSession()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoPreviewLayer!.frame = previewView.bounds
    }
    
    func setupCameraSession(){
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetMedium
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
    
    
    
    @IBAction func didTakePhoto(_ sender: AnyObject) {
        if let videoConnection = stillImageOutput!.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput?.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (sampleBuffer: CMSampleBuffer?, error: Error?) in
                if sampleBuffer != nil {
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                    let dataProvider = CGDataProvider(data: imageData as! CFData)
                    let cgImageRef = CGImage(jpegDataProviderSource: dataProvider!, decode: nil, shouldInterpolate: true, intent: CGColorRenderingIntent.defaultIntent)
                    let image = UIImage(cgImage: cgImageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    self.previewImage.image = image
                    let claimController = ClaimViewController()
                    claimController.bounty = self.currentBounty
                    let size = CGSize(width: 400, height: 400)
                    claimController.claimingImage =  self.resize(image: image, newSize: size)
                    //                        self.navigationController?.pushViewController(claimController, animated: true)
                    self.present(claimController, animated: false, completion: nil)
//                    self.cancelCamera()
                    
                }
            })
        }
    }
    
    
    @IBAction func cancelCamera(_ sender: UIButton) {
        
        dismiss(animated: true) {
            let currentCameraInput: AVCaptureInput = self.session!.inputs[0] as! AVCaptureInput
            self.session?.removeInput(currentCameraInput)
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

