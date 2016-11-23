//
//  XHERENeabyBountiesViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERENeabyBountiesViewController: UIViewController {
    
    
    @IBOutlet weak var placeNameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeimageView: UIImageView!
    var location : POI?
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpView()
        
    }
   

    @IBAction func postABountyClick(_ sender: UIButton) {
        
        let postBounty = XHEREPostBountyViewController(nibName: "XHEREPostBountyViewController", bundle: nil)
        postBounty.location = location
        self.navigationController?.pushViewController(postBounty, animated: true)
        
    }
    
    func setUpView(){
    
        placeNameLabel.text = location?.placeName
        placeimageView.setImageWith((location?.placeImageURL)!)
        imageViewHeightConstraint.constant = self.view.frame.height*0.3

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
