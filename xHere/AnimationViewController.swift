//
//  AnimationViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 12/4/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class AnimationViewController: UIViewController {
    
    var coin : UIImageView?
    var animator: UIDynamicAnimator? = nil
    let gravity = UIGravityBehavior()
    var instantaneousPush: UIPushBehavior?
    @IBOutlet weak var piggyImageView: UIImageView!
    @IBOutlet weak var testButton: UIButton!
    @IBOutlet weak var dimissButton: UIButton!
    var cancel = false
    var stopFlipping = false
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!
    var claimedImage : UIImage!
    @IBOutlet weak var numberOfTokensLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
//        piggyImageView.image = UIImage(named: "piggy")
        addCoin(location: CGRect(x: 150, y: -30, width: view.frame.width * 0.14, height: view.frame.height * 0.14))
        alertView.frame = CGRect(x: alertView.frame.origin.x, y: alertView.frame.origin.y, width: view.frame.width * 0.60, height: view.frame.height * 0.60)
         createAnimatorStuff()
    }
    
    func addCoin(location: CGRect) {
        self.view.layoutIfNeeded()
        coin = UIImageView(frame: location)
//        coin?.backgroundColor = UIColor.red
        coin?.image = UIImage(named: "coinFront")
        coin?.layer.masksToBounds = true
        coin?.clipsToBounds = true
        coin?.backgroundColor = UIColor.clear
//        coin?.layer.cornerRadius = (coin?.frame.height)!/2
//        view.insertSubview(coin!, at: 0)
        view.addSubview(coin!)
        initAnimation()
    }
    
    func initAnimation(){
        if cancel == false {
            gravity.addItem(coin!)
            //            animator?.addBehavior(instantaneousPush!)
            
            cancel = true
            startFlipping()
            collided = false
        }
        else
        {
            gravity.removeItem(coin!)
            collided = true
            cancel = false
            //            dismiss(animated: true, completion: nil)
        }
    }
    
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView: self.view)
        let collison = UICollisionBehavior()
//        collison.addItem(coin!)
        instantaneousPush = UIPushBehavior(items: [coin!], mode: UIPushBehaviorMode.instantaneous)
        instantaneousPush?.setAngle( CGFloat(M_PI_2) , magnitude: 0.3);
//        collison.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collison)
        gravity.gravityDirection = CGVector(dx: 0, dy: -1.0)
        gravity.magnitude = 0.6
        animator?.addBehavior(gravity)
        
    }
    
    var collided = false
    var green = true
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
        
        
        let stopFlippingAt = self.view.frame.height - self.view.frame.height/2
        let stopGravityAt = self.piggyImageView.frame.origin.y
      
        gravity.action = {
//  
            
            if (self.coin?.frame.origin.y)! <= CGFloat(3.0) {
                self.gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
                self.gravity.magnitude = 0.5
            }
            if(self.coin?.frame.origin.y)! > CGFloat(stopFlippingAt){
                print(self.coin!.frame.origin.y)
                self.stopFlipping = true
            }
            if(self.coin!.frame.origin.y) >= CGFloat(stopGravityAt){
                self.animator?.removeAllBehaviors()
                self.coin!.isHidden = true
                self.createAlert()
                self.showAlert()
            }
            
        }
    }
    
    func createAlert() {
        
        alertView.layer.cornerRadius = 10;
        alertView.layer.shadowColor = UIColor.black.cgColor;
        alertView.layer.shadowOffset = CGSize(width: 0, height: 5);
        alertView.layer.shadowOpacity = 0.3;
        alertView.layer.shadowRadius = 10.0;
        let user  = PFUser.current() as! User
        numberOfTokensLabel.text = "\(user.tokens)"
        self.dimissButton.addTarget(self, action: Selector("dismissAlert"), for: UIControlEvents.touchUpInside)
        
    }
    
    func showAlert() {
        createGestureRecognizer()
        animator?.removeAllBehaviors()
        
        
        // Animate the alert view using UIKit Dynamics.
        alertView.alpha = 1.0
        
        let snapBehaviour: UISnapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
        animator?.addBehavior(snapBehaviour)
    }
    
    func dismissAlert() {
        
        animator?.removeAllBehaviors()
        
        let gravityBehaviour: UIGravityBehavior = UIGravityBehavior(items: [alertView])
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 10.0)
        animator?.addBehavior(gravityBehaviour)
        
        // This behaviour is included so that the alert view tilts when it falls, otherwise it will go straight down
        let itemBehaviour: UIDynamicItemBehavior = UIDynamicItemBehavior(items: [alertView])
        itemBehaviour.addAngularVelocity(CGFloat(-M_PI_2), for: alertView)
        animator?.addBehavior(itemBehaviour)
        UIView.animate(withDuration: 0.4, animations: {
            
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
                let homeTabBarVC = XHERHomeTabBarViewController()
//                self.present(homeTabBarVC, animated: true, completion: nil)
                let imageDic = ["claimedImage":self.claimedImage]
                let notificationName = Notification.Name("CompletedClaiming")
//                NotificationCenter.default.post(name: notificationName, object: imageDic)
                NotificationCenter.default.post(name: notificationName, object: nil, userInfo: imageDic)

        })
        
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
//        UIPanGestureRecognizer(target: self, action: Selector(("handlePan")))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func handlePan(sender: UIPanGestureRecognizer) {
        
        if (alertView != nil) {
            let panLocationInView = sender.location(in: view)
            let panLocationInAlertView = sender.location(in: alertView)
            
            if sender.state == UIGestureRecognizerState.began {
                animator?.removeAllBehaviors()
                
                let offset = UIOffsetMake(panLocationInAlertView.x - alertView.bounds.midX, panLocationInAlertView.y - alertView.bounds.midY);
                attachmentBehavior = UIAttachmentBehavior(item: alertView, offsetFromCenter: offset, attachedToAnchor: panLocationInView)
                
                animator?.addBehavior(attachmentBehavior)
            }
            else if sender.state == UIGestureRecognizerState.changed {
                attachmentBehavior.anchorPoint = panLocationInView
            }
            else if sender.state == UIGestureRecognizerState.ended {
                animator?.removeAllBehaviors()
//               snapBehavior =  UISnapBehavior(item: alertView, snapTo: piggyImageView.bounds.origin)
                snapBehavior = UISnapBehavior(item: alertView, snapTo: view.center)
                animator?.addBehavior(snapBehavior)
                
                if sender.translation(in: view).y > 100 {
                    dismissAlert()
                }
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
