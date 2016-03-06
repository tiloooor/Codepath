//
//  ViewController.swift
//  Tip Calculator
//
//  Created by Vincent Le on 12/1/15.
//  Copyright © 2015 Vincent Le. All rights reserved.
//

import UIKit
import ChameleonFramework

class ViewController: UIViewController {

    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var quadSplitLabel: UILabel!
    @IBOutlet weak var triSplitLabel: UILabel!
    @IBOutlet weak var biSplitLabel: UILabel!
    @IBOutlet weak var biSplitValue: UILabel!
    @IBOutlet weak var triSplitValue: UILabel!
    @IBOutlet weak var quadSplitValue: UILabel!
    var split = false
    var tipPercentages = [0.18, 0.2, 0.22]
    var themes = ["White", "Red", "Orange", "Yellow", "Green", "Sky Blue", "Sand"]
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view, typically from a nib.
        let currency = getCurrency()
        tipLabel.text = "\(currency)0.00"
        totalLabel.text = "\(currency)0.00"
        
        //set default tip to 18%, 20%, and 22%
        let settings = NSUserDefaults.standardUserDefaults()
        settings.setInteger(18, forKey: "tip_1")
        settings.setInteger(20, forKey: "tip_2")
        settings.setInteger(22, forKey: "tip_3")
        settings.setInteger(0, forKey: "theme")
        settings.setBool(split, forKey: "split_tab")
        settings.synchronize()
        
        //set splt tab options to hidden
        showTabSplitOptions(!split)
    }
    
    func showTabSplitOptions(show: Bool) {
        biSplitLabel.hidden = show
        biSplitValue.hidden = show
        triSplitLabel.hidden = show
        triSplitValue.hidden = show
        quadSplitLabel.hidden = show
        quadSplitValue.hidden = show
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Get new settings
        let settings = NSUserDefaults.standardUserDefaults()
        let tip1 = settings.integerForKey("tip_1")
        let tip2 = settings.integerForKey("tip_2")
        let tip3 = settings.integerForKey("tip_3")
        let theme = settings.integerForKey("theme")
        let split = settings.boolForKey("split_tab")
        
        //Change values of tip in segment control
        tipControl.setTitle("\(tip1)%", forSegmentAtIndex: 0)
        tipControl.setTitle("\(tip2)%", forSegmentAtIndex: 1)
        tipControl.setTitle("\(tip3)%", forSegmentAtIndex: 2)
        
        //Set stored tip percent values
        tipPercentages = [Double(tip1) / 100, Double(tip2) / 100, Double(tip3) / 100]
        
        //calculate with new tip values
        calculate()
        
        //set split tab options
        showTabSplitOptions(!split)
        
        //load theme
        loadTheme(theme)
    }

    @IBAction func onEditingChanged(sender: AnyObject) {
        calculate()
    }
    
    func calculate() {
        let tipPercentage = tipPercentages[tipControl.selectedSegmentIndex]
        
        let billAmount : Double = NSString(string: billField.text!).doubleValue;
        let tip = billAmount * tipPercentage
        let total = tip + billAmount
        
        let currency = getCurrency()
        tipLabel.text = String(format: "\(currency)%.2f", tip)
        totalLabel.text = String(format: "\(currency)%.2f", total)
        
        if (true) {
            biSplitValue.text = String(format: "\(currency)%.2f", total / 2)
            triSplitValue.text = String(format: "\(currency)%.2f", total / 3)
            quadSplitValue.text = String(format: "\(currency)%.2f", total / 4)
        }
    }
    
    func loadTheme(index: Int) {
        print(index)
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
    
    @IBAction func onTap(sender: AnyObject) {
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrency() -> String {
        let formatter = NSNumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: NSLocale.currentLocale().localeIdentifier)
        return formatter.currencySymbol
    }
}

