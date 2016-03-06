//
//  DetailsViewController.swift
//  twatter
//
//  Created by Vincent Le on 2/20/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var retweetCount: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var screenName: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    var tweet: Tweet!
    var retweeted: Bool!
    var favorited: Bool!
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .Default
        userName.text = tweet?.user?.name
        //"22:23:19 +0000 2007"
        //10:49 AM - 18 Feb 2016
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        let months_array = dateFormatter.shortMonthSymbols
        let full_timestamp = "\(tweet.createdAt!)".characters.split(" ").map{ String($0) }
        let date = full_timestamp[0].characters.split("-").map{ String($0) }
        let year = date[0], month = Int(date[1]), day = date[2]
        let time = (full_timestamp[1] as NSString).substringWithRange(NSRange(location: 1, length: 4))
        let hour = Int((time as NSString).substringWithRange(NSRange(location:0, length:1)))
        var day_or_night: String!
        if hour < 12 {
            day_or_night = "AM"
        }
        else {
            day_or_night = "PM"
        }
        timestamp.text = "\(time) \(day_or_night) - \(day) \(months_array[month!]) \(year)"
        screenName.text = "@\(tweet!.user!.screenName!)"
        textLabel.text = tweet?.text
        let profile_picture_url = NSURL(string: (tweet.user?.profileImageUrl!)!)
        profileImage.setImageWithURL(profile_picture_url!)
        retweetCount.text = "\(tweet.retweetCount)"
        likeCount.text = "\(tweet.likeCount)"
        retweeted = tweet.retweeted
        favorited = tweet.favorited
        setButtons()
    }
    func setButtons() {
        if self.favorited == true {
            likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
        }
        else {
            likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
        }
        
        if self.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
        if segue.identifier == "toComposeFromDetail" {            let vc = segue.destinationViewController as! ComposeViewController
            vc.reply_id = tweet.id
            vc.reply_to = tweet.user?.screenName!
        }
    }
    @IBAction func onRetweet(sender: AnyObject) {
        if (self.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
            self.retweeted = false
            retweetCount.text = "\(tweet.retweetCount - 1)"
            
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
            self.retweeted = true
            retweetCount.text = "\(tweet.retweetCount + 1)"
        }
        
        TwitterClient.sharedClient.retweetWithId(tweet.id, completion: {(error) -> () in })
    }
    @IBAction func onLike(sender: AnyObject) {
        if (self.favorited == true) {
            TwitterClient.sharedClient.unlikeTweetWithId(tweet.id, completion: {(error) -> () in })
            likeButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
            self.favorited = false
            likeCount.text = "\(tweet.likeCount - 1)"
        }
        else {
            TwitterClient.sharedClient.likeTweetWithId(tweet.id, completion: {(error) -> () in })
            likeButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
            self.favorited = true
            likeCount.text = "\(tweet.likeCount + 1)"
            print("liked")
        }
        
    }
}
