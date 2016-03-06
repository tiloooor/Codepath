//
//  Tweet.swift
//  twatter
//
//  Created by Vincent Le on 2/14/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAt: NSDate?
    var id: Int
    var retweeted: Bool
    var favorited: Bool
    var likeCount: Int!
    var retweetCount: Int!
    var data: NSDictionary!
    var media_url: NSURL?
    
    init(dictionary: NSDictionary) {
        id = dictionary["id"] as! Int
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        let created_at = dictionary["created_at"] as? String
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(created_at!)
        retweeted = dictionary["retweeted"] as! Bool
        favorited = dictionary["favorited"] as! Bool
        retweetCount = dictionary["retweet_count"] as! Int
        likeCount = dictionary["favorite_count"] as! Int
        data = dictionary
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        return tweets
    }
    func fetchEntities() {
        let entities = data.valueForKey("entities")
        if let media = entities!.valueForKeyPath("media") {
            let media_path = media.valueForKeyPath("media_url_https")![0] as! String
            media_url = NSURL(string: media_path)
        }
        
    }
    
    
    func getTimeDifference() -> String! {
        let elapsedTime = NSDate().timeIntervalSinceDate(createdAt!)
        let time_in_int = NSInteger(elapsedTime)
        let (year, month, day, hours, minutes, seconds)  = convertSeconds(time_in_int)
        if year > 1 {
            return "\(year)y"
        }
        else if month > 1 {
            return "\(month)m"
        }
        else if day > 1 {
            return "\(day)d"
        }
        else if hours > 1 {
            return "\(hours)h"
        }
        else if minutes > 1 {
            return "\(minutes)m"
        }
        else {
            return "\(seconds)s"
        }
       
        
    }
    
    func convertSeconds (seconds : Int) -> (Int, Int, Int, Int, Int, Int) {
        return (seconds / 31557600, seconds / 2628000, seconds / (3600 * 24), seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
  
  

}
