//
//  FusumaCameraViewController.swift
//  xHere
//
//  Created by Developer on 11/10/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Fusuma
import Parse

class FusumaCameraViewController: UIViewController, FusumaDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    var userCreatedImage:UIImage?
    
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
        
        userCreatedImage = image
        
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
    
    @IBAction func touchOnPost(_ sender: UIButton) {
        
        let server = XHERServer.sharedInstance
        
//        if let userCreatedImage = userCreatedImage {        
//            
//            server.uploadContent(withText: "FIRST MESSAGE FROM CAMERAVC",
//                                 andImage: userCreatedImage,
//                                 success: {
//                                    print("POST 1ST CONTENT SUCCESS")
//                                },failure: {
//                                    print("POST 1ST CONTENT FAILTURE")
//                                })
//        }
        
        let user = PFUser.current() as! User
        
        let note = "POSTING 6ST BOUNTY!"
        let poi = POI()
        
        server.postBountyBy(user: user, withNote: note, atPOI: poi, withTokenValue: 11,
                            success: {
                                print("POST BOUNTY TEST")
                                
//                                XCTAssertFalse(false)
//                                
//                                expectation.fulfill()
        },
                            failure: {
                                print("POST BOUNTY TEST FAILURE")
//                                XCTAssertFalse(true)
//                                expectation.fulfill()
        })
    }

    
    // MARK: - Navigation
     @IBAction func touchOnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
     }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
 
    @IBAction func showPic(_ sender: Any) {
        
        let contentQuery = PFQuery(className: "Content")
        contentQuery.includeKey("mediaArray")
        do {
            let content = try contentQuery.getObjectWithId("DOFmwJokci") as! Content
            
            let media = content.mediaArray?[0]
            let mediaFile = media?.mediaData
            mediaFile?.getDataInBackground(block: { (data:Data?, error:Error?) in
                
                self.imageView.image = UIImage(data: data!)
                
                
                })
        }
        catch{
            
        }
    }

}
