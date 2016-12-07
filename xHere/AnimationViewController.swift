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
    var overlayView: UIView!
    var attachmentBehavior : UIAttachmentBehavior!
    var snapBehavior : UISnapBehavior!

    @IBOutlet weak var numberOfTokensLabel: UILabel!
    @IBOutlet weak var alertView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        piggyImageView.image = UIImage(named: "piggy")
        addCoin(location: CGRect(x: 150, y: 100, width: view.frame.width * 0.16, height: view.frame.height * 0.16))
         createAnimatorStuff()
    }
    
    func addCoin(location: CGRect) {
        self.view.layoutIfNeeded()
        coin = UIImageView(frame: location)
        coin?.backgroundColor = UIColor.red
        coin?.image = UIImage(named: "coinFront")
        coin?.layer.masksToBounds = true
        coin?.clipsToBounds = true
        coin?.backgroundColor = UIColor.clear
        coin?.layer.cornerRadius = (coin?.frame.height)!/2
        view.insertSubview(coin!, at: 0)
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
        UIView.transition(with: self.coin!, duration: 0.5, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            if self.green {
                self.coin?.backgroundColor = UIColor.green
                self.coin?.image = UIImage(named: "coinBack")
            }
            else {
                self.coin?.backgroundColor = UIColor.red
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
            
            if (self.coin?.frame.origin.y)! <= CGFloat(2.0) {
                self.gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
                self.gravity.magnitude = 0.3
            }
            if(self.coin?.frame.origin.y)! > CGFloat(stopFlippingAt){
                print(self.coin!.frame.origin.y)
                self.stopFlipping = true
            }
            if(self.coin!.frame.origin.y) >= CGFloat(stopGravityAt){
                self.animator?.removeAllBehaviors()
                self.createOverlay()
                self.createAlert()
                self.showAlert()
            }
            
        }
    }
    
    func createOverlay() {
        // Create a gray view and set its alpha to 0 so it isn't visible
        overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = UIColor.gray
        overlayView.alpha = 0.0
//        view.addSubview(overlayView)
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
        
        // Animate in the overlay
        UIView.animate(withDuration: 0.4) {
            self.overlayView.alpha = 0.0
        }
        
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
            self.overlayView.alpha = 0.0
            }, completion: {
                (value: Bool) in
                self.alertView.removeFromSuperview()
                self.alertView = nil
                let homeTabBarVC = XHERHomeTabBarViewController()
//                self.present(homeTabBarVC, animated: true, completion: nil)
                
                let notificationName = Notification.Name("CompletedClaiming")
                NotificationCenter.default.post(name: notificationName, object: self)

        })
        
    }
    
    func createGestureRecognizer() {
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector(("handlePan:")))
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
