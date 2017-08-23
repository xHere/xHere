//
//  XHERHomeFeedViewController.swift
//  xHere
//
//  Created by Chi Hwa Michael Ting on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import SVProgressHUD

class XHERHomeFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, XHERNearByClaimedViewCellDelegate, XHERHomeFeedVCModelDelegate  {
    
    
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
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        appLogoImageView.frame = titleView.bounds
        titleView.addSubview(appLogoImageView)
        self.navigationItem.titleView = titleView
        
        self.setupTableView()
        self.setupRefreshControl()
        
        self.callAPI(success: nil)
        
        let notificationName = Notification.Name("CompletedClaiming")
        NotificationCenter.default.addObserver(self, selector: #selector(didCompleteClaiming(sender:)), name: notificationName, object: nil)
    }
    
    func didCompleteClaiming(sender:Any) {
        self.callAPI(success: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0)
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
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(refreshControl:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        self.callAPI {
            refreshControl.endRefreshing()
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
            
            cell.nearByClaimedArray = viewModel.claimedArray
            
            cell.delegate = self
            
            return cell
        }
        
        else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHerHomeFeedUnclaimedBountyCell", for: indexPath) as! XHerHomeFeedUnclaimedBountyCell

            let cellViewModel = tableViewDataBackArray[indexPath.row]
            
            
            cell.viewModel = cellViewModel
            
            cell.claimITLabel.isHidden = false
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "XHerHomeFeedUnclaimedBountyCell", for: indexPath) as! XHerHomeFeedUnclaimedBountyCell
            
            let cellViewModel = tableViewDataBackArrayFar[indexPath.row]
            
            cell.viewModel = cellViewModel
            cell.claimITLabel.isHidden = true
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //If selected is a XHERBountyViewCell run it's builtin selected animation before pushing
        if indexPath.section == 1 {
            
            let cell = tableView.cellForRow(at: indexPath) as! XHERBountyViewCell
            cell.startSelectedAnimation(completion: {[unowned self] (selectedCell:XHERBountyViewCell) in
                
                let detailViewController = XHEREDetailViewController(nibName: "XHEREDetailViewController", bundle: nil)
                detailViewController.currentBounty = self.viewModel.unClaimedArray[indexPath.row]
                detailViewController.viewControllerMode = .claiming
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
    
    func userDidChoose(claimedBounty: XHERBounty) {
        let detailVC = XHEREDetailViewController()
        detailVC.viewControllerMode = .browsing
        detailVC.currentBounty = claimedBounty
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
