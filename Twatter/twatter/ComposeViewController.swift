//
//  ComposeViewController.swift
//  twatter
//
//  Created by Vincent Le on 2/19/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import ChameleonFramework


class ComposeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var tweetField: UITextView!
    var char_limit: Bool!
    var status: Bool!
    var reply_id: Int?
    var reply_to: String?
    var status_id: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        tweetField.delegate = self
        tweetField.becomeFirstResponder()
        if reply_to != nil {
            tweetField.text = "@\(reply_to!)"
        }
        username.text = _currentUser!.name
        screenName.text = "@\(_currentUser!.screenName!)"
        characterLabel.text = "\(140)"
        char_limit = true
        status = false
        let profile_picture_url = NSURL(string: (_currentUser?.profileImageUrl!)!)
        imageView.setImageWithURL(profile_picture_url!)
    }
   

    func textViewDidChange(textView: UITextView) { //Handle the text changes here
        let counter = textView.text.characters.count
        characterLabel.text = "\(140 - counter)"
        if counter > 140 {
            char_limit = false
        }
        else {
            char_limit = true
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didCancelTweet(sender: AnyObject) {
        
    }
    func postTweet() -> Bool {
        var status = false
        if(char_limit == true){
            let text = tweetField.text!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()) as String!
            var params: String!
            if reply_id != nil {
                params = "status=\(text)&in_reply_to_status_id=\(reply_id!)&display_coordinates=false"
            }
            else {
                params = "status=\(text)&display_coordinates=false"
            }
            status = TwitterClient.sharedClient.tweetWithParams(params, completion: {(error) -> () in })
            if status == false {
                displayAlert("Error posting tweet")
            }
        } else {
            displayAlert("Too many characters!")
        }
        return status
    }

    func displayAlert(text: String) {
        let alertController = UIAlertController(title: "Twatter", message:
            text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "postedTweet" {
            return postTweet()
        }
        else if identifier == "toMain" {
            return true
        }
        else {
            return false
        }
    }
}
