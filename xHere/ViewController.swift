//
//  ViewController.swift
//  xHere
//
//  Created by Developer on 11/7/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
        
//        PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
//        testObject[@"foo"] = @"bar";
//        [testObject saveInBackground];
        
        let testObject = PFObject.init(className: "TestObject")
        testObject["foo"] = "bar"
        testObject.saveInBackground()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

