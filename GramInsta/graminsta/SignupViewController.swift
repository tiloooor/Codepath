//
//  SignupViewController.swift
//  graminsta
//
//  Created by Vincent Le on 3/2/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import Parse

class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    func confirmUsername(completionHandler: (valid: Bool, error: NSError?) -> ()) -> () {
        print("searching for \(usernameField.text!)")
        User.searchForUser(usernameField.text!, completion: {(found, error) -> () in
            print("user is \(found)")
            completionHandler(valid: found, error: nil)
            
        })
    }
    func confirmPassword() -> Bool {
        return passwordField.text == confirmPasswordField.text
        
    }
    
    @IBAction func onSignup(sender: AnyObject) {
        print("signup button is clicked")
        if confirmPassword() {
            print("password matches")
            confirmUsername({ (found, error) -> () in
                print("\(found)")
                if !found {
                    let user = User(name: self.nameField.text!,
                        username:         self.usernameField.text!,
                        email:            self.emailField.text!,
                        password:         self.passwordField.text!)
                    user.signup({ (complete, error) -> () in
                        if complete {
                            print("signup complete for \(self.nameField.text)")
                            self.performSegueWithIdentifier("signupToTimeline", sender: nil)
                        } else {
                            print("error with \(error)")
                        }
                    })
                }
                else {
                    print(error)
                    ViewController.displayAlert("Username is already taken", vc: self)
                }
                
            })
        }
        else {
            ViewController.displayAlert("Passwords do not match", vc: self)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
