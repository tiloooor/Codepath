//
//  ProfileViewController.swift
//  graminsta
//
//  Created by Vincent Le on 3/5/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import Parse
import ALCameraViewController
import QuartzCore

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    var posts: [Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
        print(PFUser.currentUser()!["username"])
//        usernameLabel.text = PFUser.currentUser()!.valueForKey("username") as! String
//        descriptionLabel.text = PFUser.currentUser()!.valueForKey("description") as! String
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:Selector("onProfileImageTapped:"))
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
        if let image = PFUser.currentUser()!.objectForKey("profile_image") as? PFFile {
            do {
                let pic_data = try image.getData()
                let picture = UIImage(data: pic_data)
                self.profileImageView.frame = CGRectMake(0, 0, 100, 100)
                self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
                self.profileImageView.image = picture
            } catch {
            }
            
        }
        else {
            let name_array = PFUser.currentUser()?.valueForKey("name")!.componentsSeparatedByString(" ")
            profileImageView.image = FGInitialCircleImage.circleImage(name_array![0], lastName: name_array![1], size: 32, borderWidth: 5, borderColor: UIColor.blueColor(), backgroundColor: UIColor.blueColor(), textColor: UIColor.whiteColor())
        }
        collectionView.delegate = self
        collectionView.dataSource = self
        updateCollection()
    }
    func onProfileImageTapped(img: AnyObject) {
        let libraryViewController = ALCameraViewController.imagePickerViewController(true) { (image) -> Void in
            
            self.profileImageView.frame = CGRectMake(0, 0, 100, 100)
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
            self.profileImageView.image = image
            let reduced_image = Post.getPFFileFromImage(PictureViewController.resize(image!, newSize: CGSize(width: 100, height: 100)))
            PFUser.currentUser()!["profile_image"] = reduced_image
            PFUser.currentUser()!.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    print("image has been saved for user ")
                } else {
                    print("error saving image for user ")
                }
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(libraryViewController, animated: true, completion: nil)
        
    }
    func updateCollection() {
        Post.getContent (PFUser.currentUser()!.valueForKey("username") as! String, completion: { (content, error) -> () in
            self.posts = content
            self.collectionView.reloadData()
            print("\n\n\n\n\(content.count)")
        })
    }
    override func viewWillAppear(animated: Bool) {
        print(self.navigationController)
        self.navigationController?.navigationItem.title = PFUser.currentUser()!["username"].uppercaseString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let data = posts {
            return data.count
        }
        else {
            return 0
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCellCollectionViewCell
            do {
                let image = try posts![indexPath.row].picture!.getData()
                let picture = UIImage(data: image)
                cell.image.image = picture
            } catch {
//                postImageView.image = picture
            }
        return cell
    }
    
    
}
