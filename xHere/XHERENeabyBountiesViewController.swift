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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        placeNameLabel.text = location?.placeName
        placeimageView.setImageWith((location?.placeImageURL)!)
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
