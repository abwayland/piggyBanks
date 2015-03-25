//
//  PiggyBanksTVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PiggyBanksTVC: UITableViewController {

    var model = PiggyBanksModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let total = model.getTotal()
        let availFunds = model.getAvailFunds()
        let formattedTotal = NSNumberFormatter.localizedStringFromNumber(total, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        let formattedAvailFunds = NSNumberFormatter.localizedStringFromNumber(availFunds, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        self.title = formattedAvailFunds + " / " + formattedTotal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return model.getNumberOfMonths()!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return model.numberOfBanks(section)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section > 0 { return nil }
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PiggyBankCell
        if let bank = model.getBankAt(sectionIndex: indexPath.section, rowIndex: indexPath.row) {
            cell.nameLabel.text = bank.name
            let owed = bank.owed
            let balance = bank.balance
            let owedAsCurrency = stringToCurrency("\(owed)")
            let paidAsCurrency = stringToCurrency("\(balance)")
            cell.amount.text = paidAsCurrency + " / " + owedAsCurrency
            let percentPaidStr = percentPaidAsString(paid: balance, owed: owed)
            if bank.isPayable {
                cell.nameLabel.textColor = UIColor.blackColor()
                cell.amount.textColor = UIColor.blackColor()
                cell.thumbnail.image = UIImage(named:"piggybank_\(percentPaidStr)")
            } else {
                cell.nameLabel.textColor = UIColor.grayColor()
                cell.amount.textColor = UIColor.grayColor()
                cell.thumbnail.image = UIImage(named:"piggybank_gray")
            }
            let dateDay = bank.date
            let month = model.getTodaysDate().month + indexPath.section
            cell.date.text = "\(month).\(dateDay)"
            cell.paidLabel.hidden = !bank.isDue
            if bank.balance == bank.owed {
                cell.paidLabel.text = "Paid"
                cell.paidLabel.textColor = UIColor.blackColor()
            } else {
                cell.paidLabel.textColor = UIColor.redColor()
                cell.paidLabel.text = "Unpaid"
            }
        }
        return cell
    }
    
    
    func percentPaidAsString(#paid: Double, owed: Double) -> String {
        let percentage = paid / owed
        switch percentage {
        case 0:
            return "0"
        case 0.01..<0.25:
            return "1"
        case 0.25..<0.5:
            return "25"
        case 0.5..<0.75:
            return "50"
        case 0.75..<1:
            return "75"
        case 1:
            return "100"
        default:
            return "0"
        }
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
        tableView.reloadData()
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section >= 1 { return false }
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            var ipArr = [NSIndexPath]()
            for var i = 0; i < tableView.numberOfSections(); i++ {
                let ip = NSIndexPath(forRow: indexPath.row, inSection: i)
                ipArr.append(ip)
            }
            model.deleteBank(indexPath.row)
            tableView.deleteRowsAtIndexPaths(ipArr, withRowAnimation: .Left)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
//     Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if fromIndexPath.section == 0 && toIndexPath.section == 0 {
            model.moveBank(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
        }
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header = UILabel()
        header.text = monthForHeader(section)
        header.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
        header.textColor = UIColor.whiteColor()
        header.textAlignment = NSTextAlignment.Center
        header.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        return header
    }
    
    func monthForHeader(section: Int) -> String
    {
        let monthStrs = ["January","February","March","April","May","June","July","August","September","October","November", "December"]
        let monthIndex = ((model.getTodaysDate().month - 1) + section) % 12
        return monthStrs[monthIndex]
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.section >= 1 { return false }
        return true
    }
    

    
    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "edit bank" {
            if let vc = segue.destinationViewController as? PBDetailVC {
                vc.model = model
                if let cell = sender as? PiggyBankCell {
                    if let indexPath = tableView.indexPathForCell(cell) {
                        vc.bankIndex = indexPath.row
                        vc.title = "Edit Bill"
                    }
                }
            }
        } else if segue.identifier == "add bank" {
            if let vc = segue.destinationViewController as? AddBankVC {
                vc.model = model
                vc.title = "Add Bill"
            }
        } else if segue.identifier == "deposit" {
            if let vc = segue.destinationViewController as? DepositVC {
                vc.model = model
                vc.title = "Deposit / Withdraw"
            }
        }
    }
    
}
