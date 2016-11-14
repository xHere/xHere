//
//  XHERDiscoveryViewController.swift
//  xHere
//
//  Created by Developer on 11/13/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHERDiscoveryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var tableViewDataBackArray = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "DISCOVER"
        self.setupTableView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupTableView() {
//        self.automaticallyAdjustsScrollViewInsets = false
        self.edgesForExtendedLayout = []
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "POIViewCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "POIViewCell")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return tableViewDataBackArray.count
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "POIViewCell", for: indexPath)
        
        cell.textLabel?.text = "TEST"
        
        return cell
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
