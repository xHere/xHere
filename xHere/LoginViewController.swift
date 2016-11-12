//
//  LoginViewController.swift
//  xHere
//
//  Created by Singh, Jagdeep on 11/11/16.
//  Copyright © 2016 Developer. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func handleSignup(_ sender: UIButton) {
        //currently taking input inside an alert only, will eventually move it inside into different view
        let alert = UIAlertController(title: "SignUp", message: "Please enter an email and password to register", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Register", style:
        .default) { (action: UIAlertAction) in
           let newUser = PFUser()
            newUser.username = alert.textFields?[0].text!
            newUser.password = alert.textFields?[1].text!
            
            newUser.signUpInBackground(block: { (success : Bool, error : Error?) in
                if let error = error {
                    // we probably want to let user know about the error.
                    print(error.localizedDescription)
                }
                else {
                    self.login(userName: newUser.username!, password: newUser.password!)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alert.addTextField { (email :UITextField) in
            email.placeholder = "Enter Your Email here"
        }
        alert.addTextField { (password: UITextField) in
            password.placeholder = "Enter Password"
            password.isSecureTextEntry = true
        }
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func handleLogin(_ sender: UIButton) {
        let userName = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        login(userName: userName, password: password)
        
    }
    
    func login(userName: String, password: String){
        PFUser.logInWithUsername(inBackground: userName, password: password) { (user: PFUser?, error:Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print("userLogged In \(user?.username)")
                self.performSegue(withIdentifier: "segueToTimeLine", sender: nil)
            }
        }
        
    }

}
