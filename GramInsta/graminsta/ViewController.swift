//
//  ViewController.swift
//  graminsta
//
//  Created by Vincent Le on 2/25/16.
//  Copyright © 2016 QSport. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    class func displayAlert(text: String, vc: UIViewController) {
        let alertController = UIAlertController(title: "Cortera", message: text, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        vc.presentViewController(alertController, animated: true, completion: nil)
    }


}

