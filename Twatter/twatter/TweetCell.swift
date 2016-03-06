//
//  TweetCell.swift
//  twatter
//
//  Created by Vincent Le on 2/14/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import ActiveLabel
let reload = "reloadDataNotification"

protocol CellDelegate {
    func userMentionClicked(username: String)
}

class TweetCell: UITableViewCell {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyLabel: ActiveLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureLabel: UIImageView!
    var retweeted: Bool!
    var favorited: Bool!
    var media_url: NSURL?
    var delegate: CellDelegate?
    var tweet: Tweet! {
        didSet {
            nameLabel.text = tweet?.user?.name
            timestamp.text = tweet?.getTimeDifference()
            handleLabel.text = "@\(tweet!.user!.screenName!)"
            bodyLabel.text = tweet?.text
            let profile_picture_url = NSURL(string: (tweet.user?.profileImageUrl!)!)
            pictureLabel.setImageWithURL(profile_picture_url!)
            pictureLabel.layer.cornerRadius = 10.0
            pictureLabel.clipsToBounds = true
            if tweet.likeCount > 10 {
                likeCountLabel.hidden = false
                likeCountLabel.text = "\(tweet.likeCount!)"
            }
            else {
                likeCountLabel.hidden = true
            }
            if tweet.retweetCount > 5 {
                retweetCountLabel.hidden = false
                retweetCountLabel.text = "\(tweet.retweetCount!)"
            }
            else {
                retweetCountLabel.hidden = true
            }
            retweeted = tweet.retweeted
            favorited = tweet.favorited
            bodyLabel.mentionColor = UIColor.flatSkyBlueColor()
            bodyLabel.hashtagColor = UIColor.flatBlackColor()
            bodyLabel.URLColor = UIColor.flatSkyBlueColor()
            bodyLabel.handleMentionTap { userHandle in
                self.delegate?.userMentionClicked(userHandle)
            }
            bodyLabel.handleURLTap { url in
                print(url)
                UIApplication.sharedApplication().openURL(url)
            }
            setButtons()
        }
    }
    func setButtons() {
        if self.favorited == true {
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
        }
        else {
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
        }
        
        if self.retweeted == true {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func onLike(sender: AnyObject) {
        if (self.favorited == true) {
            TwitterClient.sharedClient.unlikeTweetWithId(tweet.id, completion: {(error) -> () in })
            favoriteButton.setImage(UIImage(named: "like-action.png"), forState: UIControlState.Normal)
            self.favorited = false
            likeCountLabel.text = "\(tweet.likeCount! - 1)"
        }
        else {
            TwitterClient.sharedClient.likeTweetWithId(tweet.id, completion: {(error) -> () in })
            favoriteButton.setImage(UIImage(named: "like-action-on.png"), forState: UIControlState.Normal)
            self.favorited = true
            print("liked")
            likeCountLabel.text = "\(tweet.likeCount! + 1)"
        }
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        if (self.retweeted == true) {
            retweetButton.setImage(UIImage(named: "retweet-action.png"), forState: UIControlState.Normal)
            self.retweeted = false
            retweetCountLabel.text = "\(tweet.retweetCount! - 1)"
        }
        else {
            retweetButton.setImage(UIImage(named: "retweet-action-on.png"), forState: UIControlState.Normal)
            self.retweeted = true
            retweetCountLabel.text = "\(tweet.retweetCount! + 1)"
        }
        TwitterClient.sharedClient.retweetWithId(tweet.id, completion: {(error) -> () in })
    }

}
