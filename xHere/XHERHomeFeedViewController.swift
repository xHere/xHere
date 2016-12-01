//
//  XHERHomeFeedViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

var searchDistanceInMiles = 52.0
class XHERHomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var bountiesArray:[XHERBounty]?
    var claimedBountiesArray:[XHERBounty]?
    var tableViewDataBackArray = [XHERBounty]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "HOME"
        
        self.setupTableView()
        self.setupRefreshControl()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        weak var weakSelf = self
        self.callAPI {
            weakSelf?.updateTableView()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func callAPI(success:@escaping ()->()) {
        
        let server = XHERServer.sharedInstance
        
        //Get unclaimed bounties nearby
        PFGeoPoint.geoPointForCurrentLocation { (currentLocation:PFGeoPoint?, error:Error?) in
            
            if error == nil {
                
                if let currentLocation = currentLocation {
                    weak var weakSelf = self
                    server.fetchUnClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                            success: { (bountiesArray:[XHERBounty]?) in
                            
                                if let strongSelf = weakSelf {
                                    strongSelf.bountiesArray = bountiesArray
                                    success()
                                }
                    },
                            failure: { (error:Error?) in
                            
                    })
                    
                    server.fetchClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                            success: { (claimedBountiesArray:[XHERBounty]?) in
                                weakSelf?.claimedBountiesArray = claimedBountiesArray
                                success()
                    },
                            failure: { (error:Error?) in
                                
                    })
                    
                }
            }
        }
        
        //Get claimed bounties nearby
        
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        weak var weakSelf = self
        self.callAPI {
            refreshControl.endRefreshing()
            weakSelf?.updateTableView()
        }
    }
    
    func setupTableView() {
//        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "XHERHomeFeedViewCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "XHERHomeFeedViewCell")
        
        let collectionViewNib = UINib(nibName: "XHERNearByClaimedViewCell", bundle: nil)
        self.tableView.register(collectionViewNib, forCellReuseIdentifier: "XHERNearByClaimedViewCell")
    }
    
    func updateTableView() {
        
        if let bountiesArray = bountiesArray {
            self.tableViewDataBackArray = bountiesArray
        }
        
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else {
            return tableViewDataBackArray.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHERNearByClaimedViewCell", for: indexPath) as! XHERNearByClaimedViewCell
            
            return cell
        }
        
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHERHomeFeedViewCell", for: indexPath) as! XHERHomeFeedViewCell

            let bounty = self.tableViewDataBackArray[indexPath.row]
            
            cell.bounty = bounty
            return cell
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = XHEREDetailViewController(nibName: "XHEREDetailViewController", bundle: nil)
        let cell = tableView.cellForRow(at: indexPath) as! XHERHomeFeedViewCell
        detailViewController.currentBounty = cell.bounty
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return UITableViewAutomaticDimension
        }
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
