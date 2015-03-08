//
//  PiggyBanksTVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PiggyBanksTVC: UITableViewController {

    var model: PiggyBanksModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var nib = UINib(nibName: "PiggyCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        //Uncomment the following to clear NSUserDefaults
//        let defaults = NSUserDefaults.standardUserDefaults()
//        for key in defaults.dictionaryRepresentation().keys {
//            defaults.removeObjectForKey(key.description)
//        }
        model = PiggyBanksModel()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        let total = model.getTotal()
        let availFunds = model.getAvailFunds()
        let formattedTotal = NSNumberFormatter.localizedStringFromNumber(total, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        let formattedAvailFunds = NSNumberFormatter.localizedStringFromNumber(availFunds, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        self.title =  formattedAvailFunds + " / " + formattedTotal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return model.numberOfBanks()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PiggyBankCell
        cell.thumbnail.image = UIImage(named:"piggy_orig")
         let bank = model.getBankAtIndex(indexPath.row)
            if let name = bank["name"] {
                cell.nameLabel.text = name
            }
            if let owed = bank["owed"] {
                if let paid = bank["paid"] {
                    let owedAsCurrency = stringToCurrency(owed)
                    let paidAsCurrency = stringToCurrency(paid)
                    cell.amount.text = paidAsCurrency + " / " + owedAsCurrency
                } else {
                    cell.detailTextLabel?.text = "Error"
                }
            }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 78
    }
    
    func stringToCurrency(amount: String) -> String {
        if let dub = NSNumberFormatter().numberFromString(amount)?.doubleValue {
            let currency = NSNumberFormatter.localizedStringFromNumber(dub, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
            return currency
        }
        return "error: amt to curr"
    }
    
    @IBAction func goBack(segue: UIStoryboardSegue)
    {
        if segue.identifier == "unwindAddBank" {
            if let vc = segue.sourceViewController as? AddBankVC {
                if let bank = vc.getBank() {
                    model.addBank(bank)
                    self.tableView.reloadData()
                    println("addBank")
                }
            }
        } else if segue.identifier == "unwindDeposit" {
            let vc = segue.sourceViewController as? DepositVC
            if let deposit = vc?.getDeposit() {
                model.deposit(deposit)
                println("deposit")
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    }
    


}
