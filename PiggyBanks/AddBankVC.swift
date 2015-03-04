//
//  AddBankVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

protocol addBankDelegate: class {
    func removeVC(sender: AddBankVC)
}

class AddBankVC: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var dateField: UITextField!
    
    weak var delegate: addBankDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AddBank(sender: UIButton) {
        if let name = nameField.text {
            var bank = ["name" : name]
            if let amount = amountField.text {
                bank["amount"] = amount
            }
            storeBank(bank)
            println("bank stored")
        } else {
            println("error: no name for bank")
        }
        if delegate != nil {
            delegate!.removeVC(self)
        }
    }
    
    func storeBank(bank: [String : String])
    {
        var defaults = NSUserDefaults.standardUserDefaults()
        var PBArray = [bank]
        if var oldPBArray = defaults.valueForKey("PBArray") as? Array<[String : String]> {
            PBArray = oldPBArray + PBArray
        }
        defaults.setObject(PBArray, forKey: "PBArray")
        defaults.synchronize()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let viewController = segue.destinationViewController as? UITableViewController {
            viewController.tableView.reloadData()
        }
        // Pass the selected object to the new view controller.
    }
    */
}
