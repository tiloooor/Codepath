//
//  MenuViewController.swift
//  
//
//  Created by Vincent Le on 2/7/16.
//
//

import UIKit
import SwiftyJSON
import SWRevealViewController

class MenuViewController: UITableViewController {
    var genre_list: JSON?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGenres()
    }
    
    func fetchGenres() {
        let path: NSString = NSBundle.mainBundle().pathForResource("genres", ofType: "json")!
        let data : NSData = try! NSData(contentsOfFile: path as String, options: NSDataReadingOptions.DataReadingMapped)
        let json = JSON(data: data)
        self.genre_list = (json["genres"])
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = genre_list {
            return data.count
        }
        else {
            return 0
        }
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GenreCell", forIndexPath: indexPath) as! GenreCell
        let genre = genre_list![indexPath.row] as JSON
        cell.genreLabel.text = genre["name"].stringValue
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
        if segue.identifier == "toMain" {
            let cell = sender as! GenreCell
            if let indexPath = self.tableView.indexPathForCell(cell) {
                let nav = segue.destinationViewController as! UINavigationController
                let vc = nav.viewControllers.first as! FlicksViewController
                let id = genre_list![indexPath.row]["id"].intValue
                print(id)
                vc.genre_type = id
                //segue.perform()
            }
        }
    }
    
    
}
