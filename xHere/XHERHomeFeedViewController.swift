//
//  XHERHomeFeedViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

var searchDistanceInMiles = 200.0
class XHERHomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XHERNearByClaimedViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColorMask: UIView!
    
    var bountiesArray:[XHERBounty]?
    var claimedBountiesArray:[XHERBounty]?
    var tableViewDataBackArray = [XHERBounty]()
    var tableViewDataBackArrayFar = [XHERBounty]()
    
    var userCurrentLocation:PFGeoPoint?
    
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
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
        print("Top layout guide is \(self.topLayoutGuide.length)")
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
                    self.userCurrentLocation = currentLocation
                    weak var weakSelf = self
                    server.fetchUnClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                            success: { (bountiesArray:[XHERBounty]?) in
                            
                                if let strongSelf = weakSelf {
                                    strongSelf.bountiesArray = bountiesArray
                                    
                                    server.fetchClaimedBountyNear(location: currentLocation, withInMiles: searchDistanceInMiles,
                                          success: { (claimedBountiesArray:[XHERBounty]?) in
                                                weakSelf?.claimedBountiesArray = claimedBountiesArray
                                                success()
                                    },
                                          failure: { (error:Error?) in
                                    })
  
                                }
                    },
                            failure: { (error:Error?) in
                    })
                }
            }
        }
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
    
    // MARK: - TableView Methods
    func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.register(XHerHomeFeedUnclaimedBountyCell.self, forCellReuseIdentifier: "XHerHomeFeedUnclaimedBountyCell")
        let collectionViewNib = UINib(nibName: "XHERNearByClaimedViewCell", bundle: nil)
        self.tableView.register(collectionViewNib, forCellReuseIdentifier: "XHERNearByClaimedViewCell")
        
        self.tableView.isHidden = true
    }
    
    func updateTableView() {
        
        self.tableView.isHidden = false
        
        self.tableViewDataBackArray.removeAll()
        self.tableViewDataBackArrayFar.removeAll()
        self.tableView.reloadData()
        
        if let bountiesArray = bountiesArray {
            
            for bounty in bountiesArray {
                
                if bounty.distanceFromCurrentInMiles < 0.1 {  //If bounty is close

                    self.tableViewDataBackArray.append(bounty)

                    let newIndexPath = IndexPath(row: self.tableViewDataBackArray.count-1, section: 1)
                    print("SectionRowCountBefore \(tableView.numberOfRows(inSection: 1))")
                    
                    UIView.animate(withDuration: 2, animations: {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [newIndexPath], with:.fade)
                        self.tableView.endUpdates()
                        print("SectionRowCountAfter \(self.tableView.numberOfRows(inSection: 1))")
                    })
                }
                else {
                   
                    self.tableViewDataBackArrayFar.append(bounty)

                    let newIndexPath = IndexPath(row: self.tableViewDataBackArrayFar.count-1, section: 2)
                    print("Section2RowCountBefore \(tableView.numberOfRows(inSection: 2))")
                    
                    UIView.animate(withDuration: 2, animations: {
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: [newIndexPath], with:.left)
                        self.tableView.endUpdates()
                        print("Section2RowCountAfter \(self.tableView.numberOfRows(inSection: 2))")
//                        self.tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: false)
                    })

//                    self.tableView.reloadRows(at: [newIndexPath], with: .left)

                    
//                    let indexOfFirstFar = bountiesArray.index(of: bounty)
//                    let restOfBounties = Array(bountiesArray.suffix(from: indexOfFirstFar!))
//                    self.tableViewDataBackArrayFar.append(contentsOf: restOfBounties)
//                    break
                }
            }
            
            UIView.animate(withDuration: 1, animations: {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            })
        }
        
//        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        else if section == 1{
            return tableViewDataBackArray.count
        }
        else {
            return tableViewDataBackArrayFar.count
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHERNearByClaimedViewCell", for: indexPath) as! XHERNearByClaimedViewCell
            
            cell.nearByClaimedArray = claimedBountiesArray
            
            cell.delegate = self
            
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHerHomeFeedUnclaimedBountyCell", for: indexPath) as! XHerHomeFeedUnclaimedBountyCell

            let bounty = self.tableViewDataBackArray[indexPath.row]
            
            cell.bounty = bounty
            cell.claimITLabel.isHidden = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHerHomeFeedUnclaimedBountyCell", for: indexPath) as! XHerHomeFeedUnclaimedBountyCell
            
            let bounty = self.tableViewDataBackArrayFar[indexPath.row]
            cell.bounty = bounty
            cell.claimITLabel.isHidden = true
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If selected is a XHERBountyViewCell run it's builtin selected animation before pushing
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
            cell.startSelectedAnimation(completion: { (selectedCell:XHERBountyViewCell) in
                let detailViewController = XHEREDetailViewController(nibName: "XHEREDetailViewController", bundle: nil)
                    detailViewController.currentBounty = selectedCell.bounty
                    self.navigationController?.pushViewController(detailViewController, animated: true)
            })
        }
        if indexPath.section == 2 {
            let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
            cell.startDeniedSelectionAnimation(completion: { (selectedCell:XHERBountyViewCell) in
                
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.bounds.height * 0.25
        }
        else {
            return self.view.bounds.height * 0.25
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Make all cell transparent for backgroundMask to show through
        cell.backgroundColor = UIColor.clear
        
//        if indexPath.section == 0 {
//            
//            if claimedBountiesArray != nil && (claimedBountiesArray?.count)! > 0 {
//                let nearByClaimedViewCell = cell as! XHERNearByClaimedViewCell
//                
//                nearByClaimedViewCell.collectionView.collectionViewLayout.collectionViewContentSize
//                let indexPathOfItemOne = IndexPath(item: 0, section: 0)
//                nearByClaimedViewCell.collectionView.scrollToItem(at: indexPathOfItemOne, at: .left, animated: true)
//            }
//        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if section == 2 {
            if let headerView = view as? XHERHomeFeedHeaderView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.clear
                headerView.backgroundView = backgroundView
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 2 {
            let headerView = XHERHomeFeedHeaderView()
            headerView.headerLabel.text = "Go There!"
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 {
            return 30.0
        }
        return 0
    }
    
    // MARK: - XHERBountyViewCell Delegate Methods
    func userDidSwipeCollectionViewTo(offset: CGFloat) {
        self.backgroundColorMask.alpha = offset * 0.25
    }
    
}
