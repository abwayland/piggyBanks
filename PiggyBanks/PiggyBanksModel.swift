//
//  PiggyBanksModel.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation
import UIKit

class PiggyBanksModel {
    
    private var total: Double
    private var availFunds: Double
    private var monthsArr: [[Bill]]  // Array of Array<PiggyBank>
    private var masterMonth: [Bill]
    private var numberOfMonths = 12
    var currentBillIndex = 0

    init()
    {
        total = 2000
        availFunds = 1000
        if let saves = fetchSaves() {
            masterMonth = saves
        } else {
            masterMonth = createSamples()
        }
        monthsArr = []
        copyMasterToMonthsArr()
        checkIfBillsAreDue()
        adjustPayable()
        payBills()
        calculateBanks()
    }
    
    func fetchSaves() -> [Bill]?
    {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let managedContext = appDelegate.managedObjectContext!
        
        let fetchRequest = NSFetchRequest(entityName: "Bill")
        
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as [Bill]?
        if let results = fetchedResults {
            masterMonth = results
        } else {
            println("Error fetching \(error), \(error!.userInfo)")
        }
    }
    
    func sortMaster()
    {
        masterMonth = sorted(masterMonth) { $0.date < $1.date }
    }
    
    //mark all bills in mastermonth due to be paid
    func checkIfBillsAreDue()
    {
        let today = getTodaysDate().day
        let paidCurrent = monthsArr[0].map { (var bank: PiggyBank) -> PiggyBank in
            let date = bank.date
            if today >= date {
                bank.isDue = true
            } else {
                bank.isDue = false
            }
            return bank
        }
        monthsArr[0] = paidCurrent
    }
    
    func payBills()
    {
        for (index, bill) in enumerate(monthsArr[0]) {
            if bill.isPaid && bill.isPayable {
                total -= bill.owed
            }
            if bill.date >= getTodaysDate().day {
                currentBillIndex = index
            }
        }
    }
    
    private func adjustPayable()
    {
        for billIndex in 0..<masterMonth.count {
            let cushion = masterMonth[billIndex].cushion
            for monthIndex in 0..<monthsArr.count {
                if cushion >= monthIndex && !monthsArr[monthIndex][billIndex].isDue {
                    monthsArr[monthIndex][billIndex].isPayable = true
                } else {
                    monthsArr[monthIndex][billIndex].isPayable = false
                }
            }
        }
    }
    
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
    
    func copyMasterToMonthsArr()
    {
        //TODO: masterMonth is instance
        for index in 0..<numberOfMonths {
            let copy = masterMonth
            monthsArr.append(copy)
        }
    }
    
    func createSamples() -> [Bill]
    {
        var samp1 = Bill()
        samp1.name = "Sample1"
        samp1.owed = 100
        samp1.date = 1
        samp1.cushion = 0
        return [samp1]
    }
    
    private func storeBanks() {
        
    }
    
    //loops through bills in masterMonth and based on cushion value, marks corresponding bills in monthsArr as payable or not.
    
    private func calculateBanks()
    {
        var workingTotal = total
        //check each month in monthArr to see if is payable
        for monthIndex in 0..<monthsArr.count {
            for billIndex in 0..<masterMonth.count {
                var bill = monthsArr[monthIndex][billIndex]
                if bill.isPayable {
                    if workingTotal >= bill.owed {
                        bill.balance = bill.owed
                        workingTotal -= bill.balance
                    } else {
                        bill.balance = workingTotal
                        workingTotal = 0
                    }
                    monthsArr[monthIndex][billIndex] = bill
                }
            }
        }
        availFunds = workingTotal
    }
    
    func moveBank(#fromIndex: Int, toIndex: Int) {
        let movingBank = masterMonth.removeAtIndex(fromIndex)
        masterMonth.insert(movingBank, atIndex: toIndex)
        updateModel()
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAvailFunds() -> Double {
        return availFunds
    }
    
    func deleteBank(index: Int) {
        masterMonth.removeAtIndex(index)
        updateModel()
    }
    
    func updateModel()
    {
        monthsArr = []
        copyMasterToMonthsArr()
        adjustPayable()
        checkIfBillsAreDue()
        calculateBanks()
        storeBanks()
    }
    
    func replaceBankAtIndex(index: Int, withBank bank: PiggyBank) {
        masterMonth[index] = bank
        sortMaster()
        updateModel()
    }
    
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
        masterMonth.append(bank)
        sortMaster()
        updateModel()
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