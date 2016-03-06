//
//  ProfileTweetCell.swift
//  twatter
//
//  Created by Vincent Le on 2/23/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit

class ProfileTweetCell: UITableViewCell {
    
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var pictureLabel: UIImageView!
    var media_url: NSURL?
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
            pictureLabel.userInteractionEnabled = true
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
