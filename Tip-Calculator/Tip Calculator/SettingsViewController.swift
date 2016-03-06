//
//  SettingsViewController.swift
//  Tip Calculator
//
//  Created by Vincent Le on 12/3/15.
//  Copyright © 2015 Vincent Le. All rights reserved.
//

import UIKit
import ChameleonFramework

class SettingsViewController: UIViewController {

    @IBOutlet weak var Tip1: UITextField!
    @IBOutlet weak var Tip2: UITextField!
    @IBOutlet weak var Tip3: UITextField!
    @IBOutlet weak var switchControl: UISwitch!
    @IBOutlet weak var themeControl: UIPickerView!
    var currentTheme = 0
    var themes = ["White", "Red", "Orange", "Yellow", "Green", "Sky Blue", "Sand"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let settings = NSUserDefaults.standardUserDefaults()
        let tip1 = settings.integerForKey("tip_1")
        let tip2 = settings.integerForKey("tip_2")
        let tip3 = settings.integerForKey("tip_3")
        
        Tip1.text = "\(tip1)"
        Tip2.text = "\(tip2)"
        Tip3.text = "\(tip3)"
        
        switchControl.on = false

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return themes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        //print("\(row) = \(themes[row])")
        print(themeControl.selectedRowInComponent(0))
        currentTheme = themeControl.selectedRowInComponent(0)
        loadTheme(currentTheme)
        return themes[row]
    }
    
    func loadTheme(index: Int) {
        switch index {
        case 0:
            view.backgroundColor = UIColor.whiteColor()
        case 1:
            view.backgroundColor = FlatRed()
        case 2:
            view.backgroundColor = FlatOrange()
        case 3:
            view.backgroundColor = FlatYellow()
        case 4:
            view.backgroundColor = FlatGreen()
        case 5:
            view.backgroundColor = FlatSkyBlue()
        case 6:
            view.backgroundColor = FlatSand()
        default:
            print("invalid color")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let settings = NSUserDefaults.standardUserDefaults()
        let tip1 = settings.integerForKey("tip_1")
        let tip2 = settings.integerForKey("tip_2")
        let tip3 = settings.integerForKey("tip_3")
        currentTheme = settings.integerForKey("theme")
        switchControl.on = settings.boolForKey("split_tab")
        
        Tip1.text = "\(tip1)"
        Tip2.text = "\(tip2)"
        Tip3.text = "\(tip3)"
        
        themeControl.selectRow(currentTheme, inComponent: 0, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let settings = NSUserDefaults.standardUserDefaults()
        let tip1Value : Int = NSString(string: Tip1.text!).integerValue;
        let tip2Value : Int = NSString(string: Tip2.text!).integerValue;
        let tip3Value : Int = NSString(string: Tip3.text!).integerValue;
        settings.setInteger(tip1Value, forKey: "tip_1")
        settings.setInteger(tip2Value, forKey: "tip_2")
        settings.setInteger(tip3Value, forKey: "tip_3")
        settings.setInteger(currentTheme, forKey: "theme")
        settings.setBool(switchControl.on, forKey: "split_tab")
        settings.synchronize()
    }
}
