//
//  CameraViewController.swift
//  graminsta
//
//  Created by Vincent Le on 3/5/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit
import ALCameraViewController

protocol CameraDelegate {
    func finalizePicture(image: UIImage)
}
class CameraViewController: UIViewController {
    
    var imageHolder: UIImage!
    var delegate: CameraDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        let cameraViewController = ALCameraViewController(croppingEnabled: true) { image in
            self.performSegueWithIdentifier("finalizePicture", sender: image)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        presentViewController(cameraViewController, animated: true, completion: nil)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)  {
        if segue.identifier == "finalizePicture" {
            let vc = segue.destinationViewController as! PictureViewController
            print(sender as! UIImage)
            print(vc)
            vc.picture = sender as! UIImage
            
        }
    }
}
