//
//  XHEREProfileViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/28/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class XHEREProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var coverImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var claimedButton: UIButton!
    let currentUser = User.current()
    @IBOutlet weak var postedButton: UIButton!
    var userBounties = [XHERBounty]()
    var claimedSelected = true
    var postedSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpTableView()
        getClaimedBounties()
        
    }
    
    func setUpView(){
        let logOutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(sender:)))
        self.navigationItem.leftBarButtonItem = logOutButton
        
        if currentUser?.coverPictureUrl != nil {
            let url = URL(string: (currentUser?.coverPictureUrl!)!)
            coverImage.clipsToBounds = true
            coverImage.setImageWith(url!)
        }
    }
    
    func setUpTableView(){
        tableView.dataSource = self;
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
        let cellNib = UINib(nibName: "XHERHomeFeedViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "XHERHomeFeedViewCell")
    }
    
    @IBAction func getBounties(_ sender: AnyObject) {
        if claimedSelected == true {
                getPostedBounties()
        } else {
            getClaimedBounties()
        }
        claimedSelected = !claimedSelected
        postedSelected = !postedSelected
    }
    
    func getPostedBounties(){
        XHERServer.sharedInstance.fetchBountyPostedBy(user: currentUser!, success: { (bounties: [XHERBounty]?) in
            if (bounties?.count)! > 0 {
                self.userBounties = bounties!
            }
            else {
                self.userBounties = []
            }
            self.tableView.reloadData()
            self.claimedButton.isSelected = false
            self.postedButton.isSelected = true
            
           
        }) { (error: Error?) in
            print(error)
        }
    }
    
    func getClaimedBounties(){
        XHERServer.sharedInstance.fetchBountyEarneddBy(user: currentUser!, success: { (bounties : [XHERBounty]?) in
            self.userBounties = bounties!
            self.tableView.reloadData()
            self.claimedButton.isSelected = true
            self.postedButton.isSelected = false
            
        }) { (error: Error?) in
                print(error)
        }
    }
    
    func logOut(sender:UIBarButtonItem) {
        PFUser.logOutInBackground { (error:Error?) in
            if error == nil {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "userDidLogOut"), object: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if userBounties != nil {
            return userBounties.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XHERHomeFeedViewCell", for: indexPath) as! XHERHomeFeedViewCell
        let bounty = userBounties[indexPath.row]
        cell.bounty = bounty
        return cell
    }
    
}
