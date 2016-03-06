//
//  TweetsViewController.swift
//  twatter
//
//  Created by Vincent Le on 2/14/16.
//  Copyright © 2016 Vincent Le. All rights reserved.
//

import UIKit
import ChameleonFramework


class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, CellDelegate {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    var isMoreDataLoading: Bool!
    var activityIndicatorView: UIActivityIndicatorView!
    var referenceCell: TweetCell!
    var isUserMention: Bool!
    let refresh = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        isMoreDataLoading = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        view.backgroundColor = UIColor.flatSkyBlueColor()
        navBar.barTintColor = UIColor.flatSkyBlueColor()
        let image : UIImage = UIImage(named: "Twitter_logo_white_48")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.contentMode = .ScaleAspectFit
        imageView.image = image
        navItem.titleView = imageView
        refresh.addTarget(self, action: "refreshControlAction:", forControlEvents: UIControlEvents.ValueChanged)
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, 60.0)
        activityIndicatorView = UIActivityIndicatorView(frame: frame)
        activityIndicatorView.activityIndicatorViewStyle = .Gray
        activityIndicatorView.hidesWhenStopped = true
        activityIndicatorView!.hidden = true
        tableView.addSubview(activityIndicatorView!)
        tableView.insertSubview(refresh, atIndex: 0)
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        getTimeline(["count": "50"])
        isUserMention = false
    }
    func userMentionClicked(username: String) {
        print("user mention clicked \(username)")
        isUserMention = true
        performSegueWithIdentifier("toProfile", sender: username)
    }
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.hidden = true
    }
    
    func startAnimating() {
        self.activityIndicatorView.hidden = false
        self.activityIndicatorView.startAnimating()
    }
    func loadMoreData() {
        let count = (tweets?.count)! + 50
        getTimeline((["count": count]))
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, 60.0)
                activityIndicatorView?.frame = frame
                startAnimating()
                loadMoreData()		
            }
        }
    }
    func refreshControlAction(refreshControl: UIRefreshControl) {
        getTimeline(["count":(tweets?.count)!])
        refreshControl.endRefreshing()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    @IBAction func onCompose(sender: AnyObject) {
    }
    func getTimeline(params: NSDictionary?) {
        TwitterClient.sharedClient.homeTimelineWithParams(params, completion: {(tweets, error) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
        })
        stopAnimating()
        isMoreDataLoading = false
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
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet?.fetchEntities()
        cell.tweet = tweets![indexPath.row] as Tweet
        cell.delegate = self
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
        if segue.identifier == "toDetails" {
            let cell = sender as! TweetCell
            let vc = segue.destinationViewController as! DetailsViewController
            vc.tweet = cell.tweet
            
        }
        else if segue.identifier == "toProfile" {
            if isUserMention == true {
                let username = sender as! String
                let vc = segue.destinationViewController as! ProfileViewController
                print("going to profile view")
                vc.username = username
                vc.hasProfileUser = false
            }
            else if let cell = (sender as? UIButton)!.superview?.superview as? TweetCell {
                let vc = segue.destinationViewController as! ProfileViewController
                print("going to profile view")
                vc.profileUser = cell.tweet.user
            }
        }
    }
}
