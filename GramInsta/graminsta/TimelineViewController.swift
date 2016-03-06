//
//  TimelineViewController.swift
//  graminsta
//
//  Created by Vincent Le on 2/25/16.
//  Copyright © 2016 Graminsta. All rights reserved.
//

import UIKit
import Parse
import ChameleonFramework


class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var media: [Post]? {
        didSet{
           tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Post.getContent ("", completion: { (content, error) -> () in
            self.media = content
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = media {
            return data.count
        }
        else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MediaCell", forIndexPath: indexPath) as! MediaCell
        cell.post = media![indexPath.row] as Post
        return cell
    }

    func onLogout(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.navigationController?.popViewControllerAnimated(true)
    }
}
