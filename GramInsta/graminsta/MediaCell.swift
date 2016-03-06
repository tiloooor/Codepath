//
//  MediaCell.swift
//  graminsta
//
//  Created by Vincent Le on 3/2/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import Parse
import FGInitialsCircleSwift

class MediaCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var timestamp: UILabel!
    var post: Post! {
        didSet {
            captionLabel.text = post.comment
            userLabel.text = post.author
            timestamp.text = getTimeDifference()
            do {
                let image = try post.picture!.getData()
                let picture = UIImage(data: image)
                postImageView.image = picture
            } catch {
//                postImageView.image = picture
            }
            User.getUser(post.author!, completion: {(user, error) -> () in
                print("user is \(user)")
//                let image_user = User(parseObject: user)
//                self.profileImage.image = image_user.valueForKey("profile_image") as? UIImage
                if let prof_pic = user.valueForKey("profile_image") as? PFFile {
                    do {
                        let image = try prof_pic.getData()
                        let picture = UIImage(data: image)
                        self.profileImage.frame = CGRectMake(0, 0, 32, 32)
                        self.profileImage.layer.cornerRadius = self.profileImage.frame.size.width/2
                        self.profileImage.image = picture
                    } catch {
                    }
                }
                else {
                    let name_array = user.valueForKey("name")?.componentsSeparatedByString(" ")
                    self.profileImage.image = FGInitialCircleImage.circleImage(name_array![0], lastName: name_array![1], size: 32, borderWidth: 5, borderColor: UIColor.blueColor(), backgroundColor: UIColor.blueColor(), textColor: UIColor.whiteColor())
                }
            })
        }
    }
    
    func getTimeDifference() -> String! {
        let elapsedTime = NSDate().timeIntervalSinceDate(post.timestamp!)
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
