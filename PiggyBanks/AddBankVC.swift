//
//  AddBankVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class AddBankVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    lazy private var bank: [String:String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addBank() {
        if let name = nameField.text {
            if let amount = NSNumberFormatter().numberFromString(amountField.text)?.doubleValue {
                bank["name"] = name
                bank["owed"] = "\(amount)"
                println("bank stored")
            } else {
                println("error: amount not convertible to double")
            }
        } else {
            println("error: no name entered for bank")
        }
    }
    
    func getBank() -> [String:String]
    {
        return bank
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? PiggyBanksTVC {
            addBank()
        }
        // Pass the selected object to the new view controller.
    }
    
}
