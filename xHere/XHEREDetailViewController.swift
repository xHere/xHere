//
//  XHEREDetailViewController.swift
//  xHere
//
//  Created by Ruchit Mehta on 11/14/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit

class XHEREDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var detailDesciptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextFeild: UITextField!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var commentViewBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.setupTableView()

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        commentViewBottomConstraint.constant = 60

    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupView(){
        
    }
    func setupTableView() {
        
      
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let contentViewCellNib = UINib(nibName: "CommentCell", bundle: nil)
        self.tableView.register(contentViewCellNib, forCellReuseIdentifier: "CommentCell")
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        return tableViewDataBackArray.count
        return 10
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        return cell
    }
    

    @IBAction func onCommentClick(_ sender: UIButton) {
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print(keyboardHeight)
            commentViewBottomConstraint.constant = keyboardSize.height+commentView.frame.size.height+128
        }
    }
   
}
