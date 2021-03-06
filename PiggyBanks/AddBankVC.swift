//
//  AddBankVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class AddBankVC: PBVC {
    
    @IBAction func donePressed(sender: AnyObject) {
        if addBank() {
            performSegueWithIdentifier("unwind add bank", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         nameField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBank() -> Bool {
        if var name = nameField.text {
            if name != "" {
                if !model.doesBillNameAlreadyExist(name) {
                    if let amount = NSNumberFormatter().numberFromString(amountField.text)?.doubleValue {
                        if let date = NSNumberFormatter().numberFromString(dateField.text)?.integerValue {
                            if date > 0 && date <= 31 {
                                let cushion = cushionControl.selectedSegmentIndex
                                model.addBill(name, owed: amount, day: date, cushion: cushion)
                            }
                        } else {
                            errorLabel.text = "Denied! You must enter a valid date."
                            errorLabel.hidden = false
                            return false
                        }
                    } else {
                        errorLabel.text = "Niet! You must enter a valid amount."
                        errorLabel.hidden = false
                        return false
                    }
                } else {
                    errorLabel.text = "Oofa! That name already exists."
                    errorLabel.hidden = false
                    return false
                }
            } else {
                errorLabel.text = "Nope. You must enter a valid name."
                errorLabel.hidden = false
                return false
            }
        }
        return true
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Pass the selected object to the new view controller.
//    }
    
}
