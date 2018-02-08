//
//  LoginViewController.swift
//  Parse Chat
//
//  Created by Jackson Didat on 2/5/18.
//  Copyright © 2018 jdidat. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signUp(_ sender: Any) {
        registerUser()
    }
    
    @IBAction func logIn(_ sender: Any) {
        loginUser();
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginUser() {
        
        let username = userName.text ?? ""
        let password = self.password.text ?? ""
        
        if (userName.text?.isEmpty)! || (self.password.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Invalid Input", message: "One of the Two fields entered is invalid", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        PFUser.logInWithUsername(inBackground: username, password: password) { (user: PFUser?, error: Error?) in
            if let error = error {
                print("User log in failed: \(error.localizedDescription)")
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User logged in successfully")
                // display view controller that needs to shown after successful login
            }
        }
    }
    
    func registerUser() {
        // initialize a user object
        let newUser = PFUser()
        
        // set user properties
        newUser.username = userName.text
        newUser.password = self.password.text
        
        if (userName.text?.isEmpty)! || (self.password.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Invalid Input", message: "One of the Two fields entered is invalid", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in }
            alertController.addAction(cancelAction)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
            alertController.addAction(OKAction)
        }
        
        // call sign up function on the object
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                print("User Registered successfully")
                // manually segue to logged in view
            }
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
