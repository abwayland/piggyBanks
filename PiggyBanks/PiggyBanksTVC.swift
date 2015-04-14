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
    var topCellRow: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.editButtonItem().tintColor = UIColor.orangeColor()
        self.navigationController?.toolbar.backgroundColor = UIColor.orangeColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        makeTitle()
    }
    
    override func viewDidAppear(animated: Bool) {
        if topCellRow != nil {
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: topCellRow!, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
    }
    
    func makeTitle()
    {
        let total = model.getTotal()
        let availFunds = model.getAvailFunds()
        let formattedTotal = NSNumberFormatter.localizedStringFromNumber(total, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        let formattedAvailFunds = NSNumberFormatter.localizedStringFromNumber(availFunds, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
        self.title = formattedAvailFunds + " / " + formattedTotal
        
//        let center = CGPointMake(self.view.bounds.width / 2, self.navigationController!.navigationBar.frame.size.height / 2)
        
        let availBalanceLabel = UILabel()
        availBalanceLabel.text = "avail.          balance"
        availBalanceLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleCaption1)
        availBalanceLabel.textColor = UIColor.lightGrayColor()
        availBalanceLabel.sizeToFit()
        availBalanceLabel.frame.origin = CGPointMake(self.view.bounds.width / 2 - (availBalanceLabel.bounds.width / 2), 30)
        self.navigationController?.navigationBar.addSubview(availBalanceLabel)
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
        return model.numberOfBills(section)
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as PiggyBankCell
        if let bill = model.getBillAt(sectionIndex: indexPath.section, rowIndex: indexPath.row) {
            cell.nameLabel.text = bill.name
            cell.backgroundColor = UIColor.whiteColor()
            let owed = bill.owed
            let balance = bill.balance
            let owedAsCurrency = stringToCurrency("\(owed)")
            let paidAsCurrency = stringToCurrency("\(balance)")
            cell.balanceLabel.text = paidAsCurrency
            cell.owedLabel.text = owedAsCurrency
            let percentPaidStr = percentPaidAsString(paid: balance, owed: owed)
            if bill.isPayable || bill.isDue {
                cell.nameLabel.textColor = UIColor.blackColor()
                cell.balanceLabel.textColor = UIColor.blackColor()
                cell.owedLabel.textColor = UIColor.blackColor()
                cell.thumbnail.image = UIImage(named:"piggybank_\(percentPaidStr)")
                if bill.isDue {
                    cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
                    topCellRow = indexPath.row + 1
                    if indexPath.row == model.numberOfBills(indexPath.section) - 1 {
                        topCellRow = 0
                    }
                }
            } else {
                cell.nameLabel.textColor = UIColor.grayColor()
                cell.balanceLabel.textColor = UIColor.grayColor()
                cell.owedLabel.textColor = UIColor.grayColor()
                cell.thumbnail.image = UIImage(named:"piggybank_gray")
//                cell.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
            }
            let day = bill.day
            var month = bill.month
            cell.date.text = "\(month).\(day)"
            cell.paidLabel.hidden = !bill.isDue
            if cell.paidLabel.hidden == false {
                if bill.balance == bill.owed {
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
            model.deleteBill(indexPath.row)
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
    
    @IBAction func deposit(sender: AnyObject) {
        var depositPrompt = UIAlertController(title: "Deposit / Withdraw", message: "Enter amount. Make Negative for Withdraw", preferredStyle: .Alert)
        var amountField: UITextField?
        depositPrompt.addTextFieldWithConfigurationHandler { (textField) -> Void in
            amountField = textField
            textField.placeholder = "$0.00"
            textField.keyboardType = UIKeyboardType.NumbersAndPunctuation
        }
        depositPrompt.addAction(UIAlertAction(title: "Enter", style: .Default) { (action) -> Void in
            if let textfield = amountField {
                if let amount = NSNumberFormatter().numberFromString(textfield.text)?.doubleValue {
                    self.model.deposit(amount)
                    self.makeTitle()
                    self.tableView.reloadData()
                }
            }
            })
        depositPrompt.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (_) -> Void in
        }))
        self.presentViewController(depositPrompt, animated: true, completion: nil)
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
