//
//  PBDetailVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/12/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PBDetailVC: PBVC {
    
    var bankIndex: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bank = model.getBankAt(sectionIndex: 0, rowIndex: bankIndex) {
            nameField.text = bank.name
            amountField.text = "\(bank.owed)"
            dateField.text = "\(bank.date)"
            cushionControl.selectedSegmentIndex = bank.cushion
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func savePressed(sender: AnyObject) {
        if editBank() {
            performSegueWithIdentifier("unwind edit bank", sender: self)
        }
    }
    
    func editBank() -> Bool
    {
        if let name = nameField.text {
            if name != "" {
                if let amount = NSNumberFormatter().numberFromString(amountField.text)?.doubleValue {
                    if let date = NSNumberFormatter().numberFromString(dateField.text)?.integerValue {
                        if date > 0 && date <= 31 {
                            let cushion = cushionControl.selectedSegmentIndex
                            var bank = PiggyBank(name: name, owed: amount, date: date)
                            bank.cushion = cushion
                            model.replaceBankAtIndex(bankIndex, withBank: bank)
                        }
                    } else {
                        errorLabel.text = "Oops! You must enter a valid date."
                        errorLabel.hidden = false
                        return false
                    }
                } else {
                    errorLabel.text = "Oops! You must enter a valid amount."
                    errorLabel.hidden = false
                    return false
                }
            } else {
                errorLabel.text = "Oops! You must enter a valid name."
                errorLabel.hidden = false
                return false
            }
        }
        return true

    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        
//    }


}
