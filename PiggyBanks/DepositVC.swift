//
//  DepositVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/5/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class DepositVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var amountField: UITextField!
    
    var model: PiggyBanksModel!

    @IBAction func savePressed(sender: AnyObject) {
        if enteredAmount() {
            performSegueWithIdentifier("unwind deposit", sender: self)
        }
    }
    
    func enteredAmount() -> Bool {
        if let amount = amountField.text {
            if let dub = NSNumberFormatter().numberFromString(amount)?.doubleValue {
                model.deposit(dub)
                return true
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        amountField.delegate = self
        amountField.becomeFirstResponder()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        savePressed(self)
        return true
    }

   
    //MARK: - Navigation

////     In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let vc = segue.destinationViewController as? PiggyBanksTVC {
//            vc.tableView.reloadData()
//        }
//    }


}
