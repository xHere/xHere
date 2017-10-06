//
//  XHERHomeFeedViewController.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import SVProgressHUD

fileprivate let kSection2Header = "Go There!"

class XHERHomeFeedViewController: UIViewController  {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundColorMask: UIView!
    
    var viewModel:XHERHomeFeedVCModel!
    
    //Local model simply to create an desired animation effect.
    var tableViewDataBackArray = [XHERBountyViewCellModel]()
    var tableViewDataBackArrayFar = [XHERBountyViewCellModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set title of ViewController
        let appLogo = UIImage(named: "xhere_logo")
        let appLogoImageView = UIImageView(image: appLogo)
        appLogoImageView.contentMode = .scaleAspectFit
        let naviBarsize = self.navigationController!.navigationBar.frame.size
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: naviBarsize.width, height: naviBarsize.height))
        appLogoImageView.frame = titleView.bounds
        titleView.addSubview(appLogoImageView)
        self.navigationItem.titleView = titleView
        
        self.setupTableView()
        self.setupRefreshControl()
        
        self.callAPI(success: nil)
        
        let notificationName = kNotiCompletedClaiming
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteClaiming(sender:)), name: notificationName, object: nil)
        
//        self.automaticallyAdjustsScrollViewInsets = true
        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    // Refresh the data when someone returns to this view after claiming a bounty.
    @objc func didCompleteClaiming(sender:Any) {
        self.callAPI(success: nil)
    }

    override func viewDidLayoutSubviews() {
//        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func callAPI(success: (()->())?) {
        SVProgressHUD.show()
        viewModel.getClaimedAndUnclaimedBountyNearBy {[unowned self] (claimed, unclaimed) in
            success?()
            self.reloadData()
            SVProgressHUD.dismiss()
        }
    }
}

// MARK: - RefreshControl
extension XHERHomeFeedViewController {
    fileprivate func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refreshControlAction(refreshControl: UIRefreshControl) {
        self.callAPI {
            refreshControl.endRefreshing()
        }
    }
}

// MARK: - Delegte method for user choosing a bounty
extension XHERHomeFeedViewController: XHERNearByClaimedViewCellDelegate{
    func userDidChoose(claimedBounty: XHERBounty) {
        let detailVC = XHEREDetailViewController()
        detailVC.viewControllerMode = .browsing
        detailVC.currentBounty = claimedBounty
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - TableView Methods
extension XHERHomeFeedViewController {
    
    fileprivate func setupTableView() {
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        //Registering cell for sectino 0 which contains collectionView
        let collectionViewNib = UINib(nibName: kClassNearByClaimedViewCell, bundle: nil)
        self.tableView.register(collectionViewNib, forCellReuseIdentifier: kClassNearByClaimedViewCell)
        
        //Registering cell for section 1-2 which contains bountyViewCells
        self.tableView.register(XHerHomeFeedUnclaimedBountyCell.self, forCellReuseIdentifier: kClassUnclaimedBountyCell)
        
        self.tableView.isHidden = true
    }
    
    func reloadData() {
        self.tableView.isHidden = false
        self.tableViewDataBackArray.removeAll()
        self.tableViewDataBackArrayFar.removeAll()
        self.tableView.reloadData()
        
        //Clever animation of loading viewModel's data into a local tableview data and animate each row.
        for nearViewModel in viewModel.nearUnClaimedArray {
            self.tableViewDataBackArray.append(nearViewModel)
            let newIndexPath = IndexPath(row: self.tableViewDataBackArray.count-1, section: 1)
            
            UIView.animate(withDuration: 2) {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
        for farViewModel in viewModel.farUnClaimedArray {
            self.tableViewDataBackArrayFar.append(farViewModel)
            let newIndexPath = IndexPath(row: self.tableViewDataBackArrayFar.count-1, section: 2)
            
            UIView.animate(withDuration: 2) {
                self.tableView.insertRows(at: [newIndexPath], with: .fade)
            }
        }
        UIView.animate(withDuration: 1, animations: {
            self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        })
    }
}

// MARK: UITableViewDelegate
extension XHERHomeFeedViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //If selected is a XHERBountyViewCell run it's built-in selected animation before pushing
        if indexPath.section == 1 { //Section for normal near unclaimedBounties
            
            let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
            cell.startSelectedAnimation(completion: {[unowned self] (selectedCell:XHERBountyViewCell) in
                
                let detailViewController = XHEREDetailViewController(nibName: kClassDetailViewController, bundle: nil)
                detailViewController.currentBounty = self.viewModel.unClaimedArray[indexPath.row]
                detailViewController.viewControllerMode = .claiming
                self.navigationController?.pushViewController(detailViewController, animated: true)
            })
        }
        if indexPath.section == 2 { //Section for normal far unclaimedBounties
            let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
            cell.startDeniedSelectionAnimation(completion: { (selectedCell:XHERBountyViewCell) in
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { //Section for collectionView
            return self.view.bounds.height * 0.25
        }
        else {
            return self.view.bounds.height * 0.25
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //Make all cell transparent for backgroundMask to show through
        cell.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Section for normal far unclaimedBounties
        if section == 2 { //Section for normal far unclaimedBounties
            let headerView = XHERHomeFeedHeaderView()
            headerView.headerLabel.text = kSection2Header
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //Section for normal far unclaimedBounties
        if section == 2 {
            if let headerView = view as? XHERHomeFeedHeaderView {
                let backgroundView = UIView()
                backgroundView.backgroundColor = UIColor.clear
                headerView.backgroundView = backgroundView
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 2 { //Section for normal far unclaimedBounties
            return 30.0
        }
        return 0
    }
}

// MARK: UITableViewDataSource
extension XHERHomeFeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 { //Section for collectionView
            return 1
        }
        else if section == 1 { //Section for normal near unclaimedBounties
            return tableViewDataBackArray.count
        }
        else { //Section for normal far unclaimedBounties
            return tableViewDataBackArrayFar.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 { //Section for collectionView
            let cell = tableView.dequeueReusableCell(withIdentifier: kClassNearByClaimedViewCell, for: indexPath) as! XHERNearByClaimedViewCell
            
            cell.nearByClaimedArray = viewModel.claimedArray
            
            cell.delegate = self
            
            return cell
        }
        else if indexPath.section == 1 { //Section for normal near unclaimedBounties
            let cell = tableView.dequeueReusableCell(withIdentifier: kClassUnclaimedBountyCell, for: indexPath) as! XHerHomeFeedUnclaimedBountyCell
            
            let cellViewModel = tableViewDataBackArray[indexPath.row]
            
            cell.viewModel = cellViewModel
            
            return cell
        }
        else { //Section for normal far unclaimedBounties
            let cell = tableView.dequeueReusableCell(withIdentifier: kClassUnclaimedBountyCell, for: indexPath) as! XHerHomeFeedUnclaimedBountyCell
            
            let cellViewModel = tableViewDataBackArrayFar[indexPath.row]
            
            cell.viewModel = cellViewModel
            
            return cell
        }
    }
}
