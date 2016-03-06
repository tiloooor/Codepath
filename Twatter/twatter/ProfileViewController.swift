//
//  ProfileViewController.swift
//  twatter
//
//  Created by Vincent Le on 2/23/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var backgroundCountView: UIView!
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var tweetCount: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var followerCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var tweets: [Tweet]?
    var profileUser: User?
    var username: String?
    var hasProfileUser = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        tableView.delegate = self
        tableView.dataSource = self
        var insets = tableView.contentInset;
        insets.bottom += 60;
        tableView.contentInset = insets
        tableView.estimatedRowHeight = 150.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        if hasProfileUser == false {
            setProfileUserWithUsername(username!)
        }
        else {
            let banner_image_url = NSURL(string: (profileUser?.backgroundImageUrl)!)
            let profile_picture_url = NSURL(string: (profileUser?.profileImageUrl)!)
            bannerImage.setImageWithURL(banner_image_url!)
            profileImage.setImageWithURL(profile_picture_url!)
            backgroundCountView.layer.borderColor = UIColor.lightGrayColor().CGColor
            backgroundCountView.layer.borderWidth = 1
            profileImage.layer.borderWidth = 3
            profileImage.layer.borderColor = UIColor.flatWhiteColor().CGColor
            userDescriptionLabel.text = profileUser?.userDescription
            tweetCount.text = "\(formatCount(profileUser!.tweetCount!))"
            followerCount.text = "\(formatCount(profileUser!.followers!))"
            followingCount.text = "\(formatCount(profileUser!.following!))"
            nameLabel.text = profileUser!.name
            screenNameLabel.text = "@\(profileUser!.screenName!)"
            profileImage.layer.cornerRadius = 10.0
            profileImage.clipsToBounds = true
            getTimeline()
        }

    }
    func loadViews() {
        let banner_image_url = NSURL(string: (profileUser?.backgroundImageUrl)!)
        let profile_picture_url = NSURL(string: (profileUser?.profileImageUrl)!)
        bannerImage.setImageWithURL(banner_image_url!)
        profileImage.setImageWithURL(profile_picture_url!)
        backgroundCountView.layer.borderColor = UIColor.lightGrayColor().CGColor
        backgroundCountView.layer.borderWidth = 1
        profileImage.layer.borderWidth = 3
        profileImage.layer.borderColor = UIColor.flatWhiteColor().CGColor
        userDescriptionLabel.text = profileUser?.userDescription
        tweetCount.text = "\(formatCount(profileUser!.tweetCount!))"
        followerCount.text = "\(formatCount(profileUser!.followers!))"
        followingCount.text = "\(formatCount(profileUser!.following!))"
        nameLabel.text = profileUser!.name
        screenNameLabel.text = "@\(profileUser!.screenName!)"
        profileImage.layer.cornerRadius = 10.0
        profileImage.clipsToBounds = true
        getTimeline()
    }
    func setProfileUserWithUsername(username: String) {
        TwitterClient.sharedClient.getUserWithScreename(["screen_name":username], completion: {(user, error) -> () in
            self.profileUser = user
            self.loadViews()
        })

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func getTimeline() {
        TwitterClient.sharedClient.userTimelineWithParams(["screen_name":(profileUser!.screenName)!], completion: {(tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
    }
    func formatCount(count: Int) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        if count < 10000 {
            return numberFormatter.stringFromNumber(count)!
        }
        else if count < 1000000{
            let double = String(format: "%0.1f", (Double(count) / 1000.0))
            return "\(numberFormatter.stringFromNumber((double as NSString).doubleValue)!)K"
        }
        else {
            let double = String(format: "%0.1f", (Double(count) / 1000000.0))
            return "\(numberFormatter.stringFromNumber((double as NSString).doubleValue)!)M"
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = tweets {
            return data.count
        }
        else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ProfileTweetCell", forIndexPath: indexPath) as! ProfileTweetCell
        cell.tweet = tweets![indexPath.row] as Tweet
        return cell
    }

}
