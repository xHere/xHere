//
//  XHERENeabyBountiesViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/22/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse
class XHERENeabyBountiesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    
    @IBOutlet weak var placeNameLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeimageView: UIImageView!
    var location : POI?
    var bounties : [XHERBounty]?
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setUpView()
        self.setupTableView()
        self.getNearbyClaimedBounty()
    }
   

    @IBAction func postABountyClick(_ sender: UIButton) {
        
        let postBounty = XHEREPostBountyViewController(nibName: "XHEREPostBountyViewController", bundle: nil)
        postBounty.location = location
        self.navigationController?.pushViewController(postBounty, animated: true)
        
    }
    
    func setUpView(){
        
        self.navigationController?.navigationBar.isHidden = false
        
        placeNameLabel.text = location?.placeName
        placeimageView.setImageWith((location?.placeImageURL)!)
        imageViewHeightConstraint.constant = self.view.frame.height*0.3

    }
    func setupTableView() {
//        self.edgesForExtendedLayout = []
        
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
//        let contentViewCellNib = UINib(nibName: "XHERHomeFeedViewCell", bundle: nil)
//        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "XHERHomeFeedViewCell")
        self.tableView.register(XHERBountyViewCell.self, forCellReuseIdentifier: "XHERBountyViewCell")
       
    }
    func getNearbyClaimedBounty(){
        
        PFGeoPoint.geoPointForCurrentLocation { (loc :PFGeoPoint?, error :Error?) in
            if error == nil{
//                XHERServer.sharedInstance.fetchBountyNear(location: loc!, withInMiles: 2000.0, thatIsClaimed: true, success: { (bounty : [XHERBounty]?) in
//                    
//                    self.bounties = bounty
//                    self.tableView.reloadData()
//                    
//                }) { (error : Error?) in
//                    
//                }
                
            }
        }
        
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if bounties != nil{
            return bounties!.count
        }else{
            return 0
        }
        
        
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "XHERBountyViewCell", for: indexPath) as! XHERBountyViewCell
        
        let bounty = self.bounties?[indexPath.row]
        
        cell.bounty = bounty
        return cell

        
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
