//
//  DepositVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/5/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class DepositVC: UIViewController {
    
    @IBOutlet weak var amountField: UITextField!
    
    @IBAction func enteredAmount(sender: AnyObject)
    {
        if let amount = amountField.text {
            if let dub = NSNumberFormatter().numberFromString(amount)?.doubleValue {
                let currAmount = NSNumberFormatter.localizedStringFromNumber(dub, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
//    //MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == "unwind" {
//            if let unwoundToMVC = segue.destinationViewController as? PiggyBanksTVC {
//                
//            }
//        }
//    }


}
