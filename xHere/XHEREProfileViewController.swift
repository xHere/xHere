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
    
    @IBOutlet weak var tokenLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageProfile: UIImageView!
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
        getClaimedBounties(claimedButton)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewDidLayoutSubviews() {
        //Some View config
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.size.height/2
        self.imageProfile.layer.borderWidth = 2
        self.imageProfile.layer.borderColor = kXHERYellow.cgColor
        
    }
    
    func setUpView(){
        
        
//        let logOutButton = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logOut(sender:)))
        //self.navigationItem.leftBarButtonItem = logOutButton
        
        if currentUser?.coverPictureUrl != nil {
            let url = URL(string: (currentUser?.coverPictureUrl!)!)
            coverImage.clipsToBounds = true
            coverImage.setImageWith(url!)
        }
        if currentUser?.profileImageUrl != nil{
            
            let url = (currentUser?.profileImageUrl!)!
            imageProfile.clipsToBounds = true
            imageProfile.setImageWith(url)
            
        }
        let tokens = currentUser!.tokens
        self.tokenLabel.text = "\(tokens)"
    }
    
    func setUpTableView(){
        tableView.dataSource = self;
        tableView.delegate = self
        tableView.estimatedRowHeight = 400
        tableView.register(XHERBountyViewCell.self, forCellReuseIdentifier: "XHERBountyViewCell")
    
    }
  
    
  @IBAction func getPostedBounties(_ sender: AnyObject){
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
    
    @IBAction func getClaimedBounties(_ sender: AnyObject){
        XHERServer.sharedInstance.fetchBountyEarneddBy(user: currentUser!, success: { (bounties : [XHERBounty]?) in
            if let bounties = bounties {
        
                self.userBounties = bounties
            }
            else {
                self.userBounties = []
            }
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
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return self.view.bounds.height * 0.30
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = XHEREDetailViewController(nibName: "XHEREDetailViewController", bundle: nil)
        let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
        detailViewController.currentBounty = cell.bounty
        detailViewController.viewControllerMode = .browsing
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "XHERBountyViewCell", for: indexPath) as! XHERBountyViewCell
        let bounty = userBounties[indexPath.row]
        cell.bounty = bounty
        return cell
    }
    
}
