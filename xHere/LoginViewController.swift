
//  LoginViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtils
import FacebookSDK

enum LoginSignupViewMode {
    case login
    case signup
}

class LoginViewController: UIViewController {
    
    var mode:LoginSignupViewMode = .signup
    let animateDuration = 0.25
    var animator: UIDynamicAnimator? = nil
    
    @IBOutlet weak var loginPasswordInput: loginInputView!
    
    @IBOutlet weak var loginEmailInput: loginInputView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginContentView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var loginButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginButtonVerticalCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupView: UIView!
    @IBOutlet weak var signupContentView: UIView!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signupButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var signupButtonVerticalCenterConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var signupPasswordInput: loginInputView!
    @IBOutlet weak var signupEmailInput: loginInputView!
    //MARK: - logo and constrains
    @IBOutlet weak var logoView: UIView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoButtomInSingupConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoCenterConstraint: NSLayoutConstraint!
    
    
    //    @IBOutlet weak var forgotPassTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var socialsView: UIView!
    
    //    @IBOutlet weak var emailTextField: UITextField!
    //    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleView(animated: false)
    }
    
    @IBAction func handleSignup(_ sender: UIButton) {
        if mode == .login {
            toggleView(animated: true)
        }
        else {
            let newUser = User()
            newUser.username = signupEmailInput.textFieldView.text!
            newUser.password = signupPasswordInput.textFieldView.text!
            newUser.email = signupEmailInput.textFieldView.text!
            newUser.signUpInBackground(block: { (success : Bool, error : Error?) in
                if let error = error {
                    // we probably want to let user know about the error.
                    print(error.localizedDescription)
                }
                else {
                    self.login(userName: newUser.username!, password: newUser.password!)
                }
            })
        }
        
    }
    
    @IBAction func handleLogin(_ sender: UIButton){
        if mode == .signup {
            toggleView(animated:true)
        }
        else {
                    let userName = loginEmailInput.textFieldView.text!
                    let password = loginPasswordInput.textFieldView.text!
                    login(userName: userName, password: password)
        }
    }
    
    
    
    
    func login(userName: String, password: String){
        User.logInWithUsername(inBackground: userName, password: password) { (user: PFUser?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("userLogged In \(user?.username)")
                //                self.performSegue(withIdentifier: "segueToTimeLine", sender: nil)
                self.openNextController()
               
                
            }
        }
        
    }
    
    func toggleView(animated: Bool){
        mode = mode == .login ? .signup:.login
        loginWidthConstraint.isActive = mode == .signup ? true:false
        loginButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(mode == .login ? 300:900))
        signupButtonVerticalCenterConstraint.priority = UILayoutPriority(rawValue: UILayoutPriority.RawValue(mode == .signup ? 300:900))
        
        self.view.endEditing(true)
        
        UIView.animate(withDuration: animated ? animateDuration : 0) {
            self.view.layoutIfNeeded()
            
            //hide or show views
            self.loginContentView.alpha = self.mode == .login ? 1:0
            self.signupContentView.alpha = self.mode == .signup ? 1:0
            
            //rotate and scale login button
            let scaleLogin:CGFloat = self.mode == .login ? 1:0.4
            let rotateAngleLogin:CGFloat = self.mode == .login ? 0:CGFloat(-M_PI_2)
            
            var transformLogin = CGAffineTransform(scaleX: scaleLogin, y: scaleLogin)
            transformLogin = transformLogin.rotated(by: rotateAngleLogin)
            self.loginButton.transform = transformLogin
            
            
            // rotate and scale signup button
            let scaleSignup:CGFloat = self.mode == .signup ? 1:0.4
            let rotateAngleSignup:CGFloat = self.mode == .signup ? 0:CGFloat(-M_PI_2)
            
            var transformSignup = CGAffineTransform(scaleX: scaleSignup, y: scaleSignup)
            transformSignup = transformSignup.rotated(by: rotateAngleSignup)
            self.signupButton.transform = transformSignup
            
            let bounds = self.socialsView.bounds
            print(bounds)
            print(self.mode)
            self.animator = UIDynamicAnimator(referenceView: self.view)
            var points = CGPoint()
            if self.mode == .login{
//                points = CGPoint(x: self.loginView.center.x, y: self.socialsView.bounds.midY)
                print(self.socialsView.center.x)
                points = CGPoint(x: self.socialsView.center.x, y: self.loginButton.center.y + 90)
            }
            else {
                points = CGPoint(x: self.signupView.center.x, y: self.signupButton.center.y + 90)
            }
            let snapBehaviour: UISnapBehavior = UISnapBehavior(item: self.socialsView, snapTo: points)
            self.animator?.addBehavior(snapBehaviour)
        }
        
    }
    
    func openNextController(){
        
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied:
                let locationReq = XHERELocationRequestViewController(nibName: "XHERELocationRequestViewController", bundle: nil)
                
                self.present(locationReq, animated: true, completion: nil)
                
                
            case .authorizedAlways, .authorizedWhenInUse:
                let homeTabBarVC = XHERHomeTabBarViewController()
                self.present(homeTabBarVC, animated: false, completion: nil)
                
                
            }
        } else {
            print("Location services are not enabled")
            let locationReq = XHERELocationRequestViewController(nibName: "XHERELocationRequestViewController", bundle: nil)
            
            self.present(locationReq, animated: true, completion: nil)
            
        }

       
    }
    
    @IBAction func loginWithFacebook(_ sender: UIButton) {
        let permissions = ["public_profile", "email"]
        PFFacebookUtils.logIn (withPermissions: permissions) { (fbUser: PFUser?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                FBRequestConnection.start(withGraphPath: "me?fields=birthday,gender,first_name,last_name,picture,cover,email", completionHandler: { (connection :FBRequestConnection?, result: Any?, error: Error?) in
                    
                    let user = User.current()
                    if fbUser?.isNew == true {
                        user?.tokens = 1000
                    }
                    let data = result as! NSDictionary
                    print(data)
                    let picture = data["picture"] as! NSDictionary
                    let pictureData = picture["data"] as! NSDictionary
                    let url = URL(string: pictureData["url"] as! String)
                    let imageData = NSData.init(contentsOf: url!)
                    let profilePicture = PFFile(name: "profileImage.jpg", data: imageData! as Data)
                    //                    let profilePicture = PFFile(data: imageData! as Data)
                    let cover = data["cover"] as! NSDictionary
                    let coverUrl = URL(string: cover["source"] as! String)
                    let coverImageData = NSData.init(contentsOf: coverUrl!)
                    let coverPicture  = PFFile(name: "coverImage.jpg", data: coverImageData! as Data)
                    user?.setObject(profilePicture!, forKey: "profileImage")
                    user?.setObject(coverPicture!, forKey: "coverPictrue")
                    user?.setValue(cover["source"], forKey: "coverPictureUrl")
                    user?.setValue(pictureData["url"], forKey: "profilePictureUrl")
                    user?.email = data["email"] as? String
                    user?.username = data["email"] as? String
                    user?.lastName = data["last_name"] as? String
                    user?.firstName = data["first_name"] as? String
                    user?.coverPictureUrl = cover["source"] as? String
//                    user?.setValue(data["email"], forKey: "email")
//                    user?.setValue(data["email"], forKey: "username")
//                    user?.setValue(data["last_name"], forKey: "lastName")
//                    user?.setValue(data["first_name"], forKey: "firstName")
                    user?.saveInBackground()
//                    let homeTabBarVC = XHERHomeTabBarViewController()
//                    self.present(homeTabBarVC, animated: true, completion: nil)
                    
                   self.openNextController()
                
                    
                })
            }
        }
    }
    
}
