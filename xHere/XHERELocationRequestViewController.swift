//
//  XHERELocationRequestViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 12/6/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import STLocationRequest
class XHERELocationRequestViewController: UIViewController,STLocationRequestControllerDelegate {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let locationRequestController = STLocationRequestController.getInstance()
        locationRequestController.titleText = "We need your location for some awesome features"
        locationRequestController.allowButtonTitle = "Alright"
        locationRequestController.notNowButtonTitle = "Not now"
        locationRequestController.authorizeType = .requestAlwaysAuthorization
        locationRequestController.delegate = self
        //locationRequestController.present(onViewController: self)
        locationRequestController.view.frame = self.view.frame
        self.view.addSubview(locationRequestController.view)

        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        
        
        
       
        
    }
   
    
    func locationRequestControllerDidChange(_ event: STLocationRequestControllerEvent) {
        switch event {
        case .locationRequestAuthorized:
            self.showHomePage()
            break
        case .locationRequestDenied:
            self.showHomePage()
            break
        case .notNowButtonTapped:
            self.showHomePage()
            break
        case .didPresented:
            break
        case .didDisappear:
            break
        }
    }
    func showHomePage(){
        
        //self.dismiss(animated: true, completion: nil)
        let homeTabBarVC = XHERHomeTabBarViewController()
        self.present(homeTabBarVC, animated: false, completion: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
