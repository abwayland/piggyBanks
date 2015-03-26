//
//  PiggyBanksTVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PiggyBanksTVC: UITableViewController {
    
//    MARK: Application LifeCycle

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
        self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: model.currentBillIndex, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//     MARK: - TableView DataSource

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return model.getNumberOfMonths()!
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.numberOfBanks(section)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PiggyBankCell
        if let bank = model.getBankAt(sectionIndex: indexPath.section, rowIndex: indexPath.row) {
            cell.nameLabel.text = bank.name
            cell.backgroundColor = UIColor.whiteColor()
            let owed = bank.owed
            let balance = bank.balance
            let owedAsCurrency = stringToCurrency("\(owed)")
            let paidAsCurrency = stringToCurrency("\(balance)")
            cell.balanceLabel.text = paidAsCurrency
            cell.owedLabel.text = owedAsCurrency
            let percentPaidStr = percentPaidAsString(paid: balance, owed: owed)
            if bank.isPayable || bank.isDue {
                cell.nameLabel.textColor = UIColor.blackColor()
                cell.balanceLabel.textColor = UIColor.blackColor()
                cell.owedLabel.textColor = UIColor.blackColor()
                cell.thumbnail.image = UIImage(named:"piggybank_\(percentPaidStr)")
                if bank.isDue {
                    cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                }
            } else {
                cell.nameLabel.textColor = UIColor.grayColor()
                cell.balanceLabel.textColor = UIColor.grayColor()
                cell.owedLabel.textColor = UIColor.grayColor()
                cell.thumbnail.image = UIImage(named:"piggybank_gray")
//                cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
            let dateDay = bank.date
            var month = (model.getTodaysDate().month + indexPath.section) % 12
            if month == 0 { month = 12 }
            cell.date.text = "\(month).\(dateDay)"
            cell.paidLabel.hidden = !bank.isDue
            if cell.paidLabel.hidden == false {
                if bank.balance == bank.owed {
                    cell.balanceLabel.textColor = UIColor.greenColor()
                    cell.paidLabel.text = "Paid"
                    cell.paidLabel.textColor = UIColor.greenColor()
                } else {
                    cell.balanceLabel.textColor = UIColor.redColor()
                    cell.paidLabel.textColor = UIColor.redColor()
                    cell.paidLabel.text = "Unpaid"
                }
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
        }
    }
    
////     Override to support rearranging the table view.
//    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
//        if fromIndexPath.section == 0 && toIndexPath.section == 0 {
//            model.moveBank(fromIndex: fromIndexPath.row, toIndex: toIndexPath.row)
//        }
//        tableView.reloadData()
//    }
    
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

//    // Override to support conditional rearranging of the table view.
//    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return NO if you do not want the item to be re-orderable.
//        if indexPath.section >= 1 { return false }
//        return true
//    }
    
    // MARK: - Navigation
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.section >= 1 { return false }
        return true
    }
    
//    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
//        performSegueWithIdentifier("edit", sender: tableView.cellForRowAtIndexPath(indexPath))
//    }
    
    @IBAction func goBack(segue: UIStoryboardSegue)
    {
        tableView.reloadData()
    }

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let nc = segue.destinationViewController as? UINavigationController {
            if segue.identifier == "edit" {
                if let vc = nc.childViewControllers[0] as? PBDetailVC {
                    vc.model = model
                    if let cell = sender as? PiggyBankCell {
                        if let indexPath = tableView.indexPathForCell(cell) {
                            vc.bankIndex = indexPath.row
                            vc.title = "Edit Bill"
                        }
                    }
                }
            } else if segue.identifier == "add bank" {
                if let vc = nc.childViewControllers[0] as? AddBankVC {
                    vc.model = model
                    vc.title = "Add Bill"
                }
            } else if segue.identifier == "deposit" {
                if let vc = nc.childViewControllers[0] as? DepositVC {
                    vc.title = "Deposit / Withdraw"
                    vc.model = model
                }
            }
        }
    }
    
}
