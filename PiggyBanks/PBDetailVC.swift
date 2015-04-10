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
    var billName: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        if let bill = model.getBillAt(sectionIndex: 0, rowIndex: bankIndex) {
            self.billName = bill.name
            nameField.text = bill.name
            amountField.text = String(format: "%.2f", bill.owed)
            dateField.text = "\(bill.day)"
            cushionControl.selectedSegmentIndex = Int(bill.cushion)
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
                            model.updateBill(bill: billName, newName: name, owed: amount, date: date, cushion: cushion)
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
