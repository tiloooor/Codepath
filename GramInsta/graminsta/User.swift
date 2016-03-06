//
//  User.swift
//  graminsta
//
//  Created by Vincent Le on 3/2/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import Parse

class User: NSObject{
    var name: String?
    var username: String?
    var password: String?
    var email: String?
    var parseUser: PFUser!
    var profileImage: UIImage?
    init(name: String, username: String, email: String, password: String) {
        super.init()
        self.name               = name
        self.username           = username
        self.email              = email
        self.password           = password
        self.parseUser          = PFUser()
        self.parseUser["name"]  = name
        self.parseUser.email    = email
        self.parseUser.username = username
        self.parseUser.password = password
    }
    init(parseObject: PFObject) {
        super.init()
        print("initiializing user ")
        print("\( parseObject)")//.valueForKey("name"))")
        print("\(parseObject["name"])")
        
        self.name     = parseObject["name"] as! String
        if let image = parseObject.objectForKey("profile_image") {
            profileImage = image as! UIImage
        }
        else {
            let name_array = self.name?.componentsSeparatedByString(" ")
            profileImage = FGInitialCircleImage.circleImage(name_array![0], lastName: name_array![1], size: 32, borderWidth: 5, borderColor: UIColor.blueColor(), backgroundColor: UIColor.blueColor(), textColor: UIColor.whiteColor())
        }
        self.username = parseObject["username"] as! String
        self.email    = parseObject["email"] as! String
    }
    func signup(completion: (complete: Bool, error: NSError?) -> ()) {
        parseUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                completion(complete: success, error: nil)
                print("created account for \(self.username)")
            } else {
                completion(complete: success, error: error)
                print("failed creating account for \(self.username)")
            }
        }
    }
    func updateAttrs(params: NSDictionary) {
        for (key, value) in params {
            parseUser[key as! String] = value
            parseUser.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("\(key) has been saved for user \(self)")
                } else {
                    print("error saving \(key) for user \(self)")
                }
            }
        }
    }
    class func getUser(username: String, completion: (user: PFObject, error: NSError?) -> ()) {
        let query = PFQuery(className: "_User")
        query.whereKey("username", matchesRegex: username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
                print("\(error) and \(objects)")
            if error == nil {
                    completion(user: objects![0], error: nil)
            } else {
                print("error querying for user \(username) \n\n \(error)")
                completion(user:PFObject(), error: error)
            }
            
        }
    }
    class func searchForUser(username: String, completion: (found: Bool, error: NSError?) -> ()) {
        let query = PFQuery(className: "_User")
        query.whereKey("username", matchesRegex: username)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
                print("\(error) and \(objects)")
            if error == nil {
                if objects!.count > 0 {
                    completion(found:true, error: nil)
                }
                else {
                    print("did not find a \(username)")
                    completion(found:false, error: nil)
                }
            } else {
                print("error querying for user \(username) \n\n \(error)")
                completion(found:false, error: error)
            }
            
        }
    }
}
