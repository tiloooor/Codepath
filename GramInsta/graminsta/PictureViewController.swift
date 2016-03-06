//
//  PictureViewController.swift
//  graminsta
//
//  Created by Vincent Le on 3/5/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import MBProgressHUD

class PictureViewController: UIViewController, CameraDelegate {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    var picture: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBarHidden = true
        imageView.image = picture!
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func finalizePicture(image: UIImage) {
        imageView.image = image
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "sharePicture" {
        }
    }
    class func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    @IBAction func submitPicture(sender: AnyObject) {
         MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        Post.postUserImage(PictureViewController.resize(picture!, newSize: CGSize(width: 320, height: 320)), withCaption: textView.text!) {(success: Bool, error: NSError?) -> Void in
            if success{
                 MBProgressHUD.hideHUDForView(self.view, animated: true)
                self.performSegueWithIdentifier("submitPicture", sender: nil)
            }
            else {
                print("error sharing picture \(error)")
                ViewController.displayAlert("Error sharing picture", vc: self)
            }
            
        }
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }
}
