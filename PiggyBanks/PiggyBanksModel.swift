//
//  PiggyBanksModel.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

typealias PiggyBank = [String:String]

class PiggyBanksModel {
    
    //array of piggy banks
//    private var pbArray = [PiggyBank]?()
    private var total: Double
    private var availFunds: Double
    private var monthsArr = [[PiggyBank]]()  // Array of Array<PiggyBank>
    private var masterMonth: [PiggyBank]
    private var numberOfMonths = 3

    init()
    {
        //get number of months to display
        //create pbArray
        masterMonth = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 0
        }
        availFunds = total
        if let oldMaster = defaults.objectForKey("masterMonth") as? [PiggyBank] {
            masterMonth = oldMaster
        } else {
            masterMonth = createSamples()
        }
        for var i = 0; i < numberOfMonths; i++ {
            monthsArr.append(masterMonth)
        }
        adjustPayable()
        payBills()
        calculateBanks()
        storeBanks()
    }
    
    //mark all bills in mastermonth due to be paid
    func payBills()
    {
        let today = getTodaysDate().day
        let paidMaster = masterMonth.map { (var bank: PiggyBank) -> PiggyBank in
            let date = NSNumberFormatter().numberFromString(bank["date"]!)?.integerValue
            if today >= date {
                bank["isDue"] = "yes"
            }
            return bank
        }
        masterMonth = paidMaster
    }
    
    //TODO: monthArray never gets set
    
    func getTodaysDate() -> (month: Int, day: Int, year: Int)
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(.MonthCalendarUnit | .DayCalendarUnit | .YearCalendarUnit, fromDate: date)
        let month = components.month
        let day = components.day
        let year = components.year
        return (month, day, year)
    }
    
    func createSamples() -> [PiggyBank]
    {
        let samp1: PiggyBank = ["name":"Some Bill","balance":"0","owed":"100","date":"1","payable":"no","cushion":"2","isDue":"no"]
        let samp2: PiggyBank = ["name":"Another Bill","balance":"0","owed":"50","date":"15","payable":"no", "cushion":"2","isDue":"no"]
        let samp3: PiggyBank = ["name":"Yet Another Bill","balance":"0","owed":"25","date":"30","payable":"no","cushion":"0","isDue":"no"]
        return [samp1,samp2,samp3]
    }
    
    private func storeBanks() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(total, forKey: "total")
        defaults.setObject(masterMonth, forKey: "masterMonth")
        defaults.synchronize()
    }
    
    //loops through bills in masterMonth and based on cushion value, marks corresponding bills in monthsArr as payable or not.
    private func adjustPayable()
    {
        for billIndex in 0..<masterMonth.count {
            let bank = masterMonth[billIndex]
            if let cushionNum = NSNumberFormatter().numberFromString(bank["cushion"]!)?.integerValue {
                for monthIndex in 0..<monthsArr.count {
                    if monthIndex <= cushionNum {
                        monthsArr[monthIndex][billIndex]["payable"] = "yes"
                    } else {
                        monthsArr[monthIndex][billIndex]["payable"] = "no"
                    }
                }
            }
        }
    }
    
    private func calculateBanks()
    {
        
        func markPaid(bank: PiggyBank)
        {
            if bank["isDue"] == "yes"{
                
            }
        }
        
        var workingTotal = total
        var mutYearArray = monthsArr
        //check each month in monthArr to see if is payable
        for monthIndex in 0..<monthsArr.count {
            for billIndex in 0..<masterMonth.count {
                var bill = monthsArr[monthIndex][billIndex]
                if let owedString = bank["owed"] {
                    if let owed = NSNumberFormatter().numberFromString(owedString)?.doubleValue {
                        var balance = 0.0
                        if let payable = bank["payable"] {
                            // if it is payable work bill into calculation
                            if payable == "yes" {
                                //if workingTotal is greater than what is owed, pay bill, subtract owed from workingTotal
                                if workingTotal > owed {
                                    balance = owed
                                    bank["balance"] = "\(balance)"
                                    workingTotal -= owed
                                    markPaid(bank)
                                //else add whatever is left to bill, working total is now zero
                                } else {
                                    balance = workingTotal
                                    workingTotal = 0
                                    markPaid(bank)
                                }
                            }
                        }
                        //whatever the working total equals is what you have left to spend
                        availFunds = workingTotal
                        //bank key "paid" is updated
                        bill["balance"] = "\(balance)"
                        //mutable copy of the yearArray is updated with mutated bank
                        mutYearArray[monthIndex][billIndex] = bill
                    }
                }
            }
        }
        //year Array is replaced with mutated year array
        monthsArr = mutYearArray
        
    }
    
    func moveBank(#fromIndex: Int, toIndex: Int) {
        for index in 0..<monthsArr.count {
            let movingBank = monthsArr[index].removeAtIndex(fromIndex)
            monthsArr[index].insert(movingBank, atIndex: toIndex)
        }
        calculateBanks()
        storeBanks()
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAvailFunds() -> Double {
        return availFunds
    }
    
    func deleteBank(index: Int) {
        for yIndex in 0..<monthsArr.count {
            monthsArr[yIndex].removeAtIndex(index)
        }
        calculateBanks()
        storeBanks()
    }
    
//    func replaceBankAtIndex(index: Int, withBank bank: PiggyBank) {
//        pbArray?[index] = bank
//    }
    
    func deposit(amount: Double) {
        total += amount
        calculateBanks()
        storeBanks()
    }
    
    func withdraw(amount: Double) {
        total -= amount
        calculateBanks()
        storeBanks()
    }
    
    func addBank(bank: PiggyBank) {
        var mutYearArray = monthsArr
        for (index, month) in enumerate(monthsArr) {
            mutYearArray[index].append(bank)
        }
        monthsArr = mutYearArray
        adjustPayable()
        calculateBanks()
        storeBanks()
    }
    
    func getBankAt(#sectionIndex: Int, rowIndex: Int) -> PiggyBank?   {
        return monthsArr[sectionIndex][rowIndex]
    }
    
    func numberOfBanks(index: Int) -> Int {
        return monthsArr[index].count
    }
    
    func getNumberOfMonths() -> Int? {
        return monthsArr.count
    }
    
}