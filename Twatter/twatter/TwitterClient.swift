//
//  TwitterClient.swift
//  twatter
//
//  Created by Vincent Le on 2/14/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterAPIKey = "IS6RDJjp2kNbsTmnjIMtU51rh"
let twitterAPISecret = "MT7hqNoe2E3oQV5jfjahCDoIONgXASPeyiiAxgHSmWubZBTk37"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedClient: TwitterClient {
        struct Static {
            static let client = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterAPIKey, consumerSecret: twitterAPISecret)
            
        }
        return Static.client
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        //Fetch request token and redirect to authorization page
        TwitterClient.sharedClient.requestSerializer.removeAccessToken()
        TwitterClient.sharedClient.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitter-vincent://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
                print("got request token!")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }, failure:{(error: NSError!) -> Void in
                print("didn't get request token")
                self.loginCompletion?(user: nil, error: error)
        })
    }
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json",parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting timeline\(params) and \(error)")
        })
    }
    func userTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/user_timeline.json",parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting user timeline\(params) and \(error)")
        })
    }
    func likeTweetWithId(id: Int?, completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/create.json?id=\(id!)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                print("success liking")
           
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error liking\(id!)")
        })
    }
    func unlikeTweetWithId(id: Int?, completion: (error: NSError?) -> ()) {
        POST("1.1/favorites/destroy.json?id=\(id!)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success unliking")
            
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error unliking\(id!)")
        })
    }
    func retweetWithId(id: Int?, completion: (error: NSError?) -> ()) {
        POST("1.1/statuses/retweet/\(id!).json", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success retweeting")
            
            
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error retweeting\(id!)")
                print("1.1/statuses/retweet/\(id!).json")
        })
    }
    func tweetWithParams(params: String, completion: (error: NSError?) -> ()) -> Bool{
        var counter = true
        POST("1.1/statuses/update.json?\(params)", parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            print("success posting tweet")
                NSNotificationCenter.defaultCenter().postNotificationName(reload, object: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error 1.1/statuses/update.json?status=\(params) and \(error)")
                counter = false
        })
        return counter
    }
    func getUserWithScreename(params: NSDictionary?, completion: (user: User, error: NSError?) -> ()) {
        GET("1.1/users/show.json",parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                print(response)
                completion(user: user, error: nil)
            }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                print("error getting user timeline\(params) and \(error)")
        })
    }

    
    func openURL(url: NSURL) {
        TwitterClient.sharedClient.fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: {(accessToken: BDBOAuth1Credential!) -> Void in
            print("got access token")
            TwitterClient.sharedClient.requestSerializer.saveAccessToken(accessToken)
            
            TwitterClient.sharedClient.GET("1.1/account/verify_credentials.json",parameters: nil, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
                //print("user: \(response)")
                let user = User(dictionary: response as! NSDictionary)
                print(response)
                User.currentUser = user
                //print("user: \(user.name)")
                self.loginCompletion?(user: user, error: nil)
                }, failure: { (operation: NSURLSessionDataTask?, error: NSError!) -> Void in
                    print("error getting user")
                    self.loginCompletion?(user: nil, error: error)
            })
         
            
            }, failure: {(error: NSError!) -> Void in
                print("failed to get access token")
                self.loginCompletion?(user: nil, error: error)
        })
        
        
    }
}
