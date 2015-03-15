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
    private var deposit: Double?
    
    func enteredAmount() {
        if let amount = amountField.text {
            if let dub = NSNumberFormatter().numberFromString(amount)?.doubleValue {
                deposit = dub
            }
        }
    }
    
    func getDeposit() -> Double? {
        return deposit
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        amountField.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
        amountField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        performSegueWithIdentifier("unwindDeposit", sender: self)
        println("return")
        return true
    }

   
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        enteredAmount()
    }


}
