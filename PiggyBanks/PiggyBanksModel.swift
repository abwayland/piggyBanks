//
//  PiggyBanksModel.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

class PiggyBanksModel {
    
    private var total: Double
    private var availFunds: Double
    private var monthsArr: [[PiggyBank]]  // Array of Array<PiggyBank>
    private var masterMonth: [PiggyBank]
    private var numberOfMonths = 3

    init()
    {
        //get number of months to display
        //create pbArray
        total = 2000
        availFunds = 1000
        masterMonth = []
        monthsArr = []
        createSamples()
        copyMasterToMonthsArr()
        adjustPayable()
        calculateBanks()
    }
    
    //mark all bills in mastermonth due to be paid
//    func payBills()
//    {
//        let today = getTodaysDate().day
//        let paidMaster = masterMonth.map { (var bank: PiggyBank) -> PiggyBank in
//            let date = NSNumberFormatter().numberFromString(bank["date"]!)?.integerValue
//            if today >= date {
//                bank["isDue"] = "yes"
//            }
//            return bank
//        }
//        masterMonth = paidMaster
//    }
    
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
    
    func copyMasterToMonthsArr()
    {
        //TODO: masterMonth is instance
        for index in 0..<numberOfMonths {
            let copy = masterMonth
            monthsArr.append(copy)
        }
    }
    
    func createSamples()
    {
        var samp1 = PiggyBank(name: "Sample1", owed: 500, date: 1)
        samp1.cushion = 1
        let samp2 = PiggyBank(name: "Sample2", owed: 250, date: 15)
        let samp3 = PiggyBank(name: "Sample3", owed: 100, date: 30)
        masterMonth = [samp1, samp2, samp3]
    }
    
    private func storeBanks() {
        //To Learn How To Do
    }
    
    //loops through bills in masterMonth and based on cushion value, marks corresponding bills in monthsArr as payable or not.
    private func adjustPayable()
    {
        for billIndex in 0..<masterMonth.count {
            let cushion = masterMonth[billIndex].cushion
            for monthIndex in 0..<monthsArr.count {
                if cushion >= monthIndex {
                    monthsArr[monthIndex][billIndex].payable = true
                } else {
                    monthsArr[monthIndex][billIndex].payable = false
                }
            }
        }
    }
    
    private func calculateBanks()
    {
        var workingTotal = total
        //check each month in monthArr to see if is payable
        for monthIndex in 0..<monthsArr.count {
            for billIndex in 0..<masterMonth.count {
                var bill = monthsArr[monthIndex][billIndex]
                if bill.payable {
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
        masterMonth.removeAtIndex(index)
        monthsArr = []
        copyMasterToMonthsArr()
        adjustPayable()
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
        masterMonth.append(bank)
        monthsArr = []
        copyMasterToMonthsArr()
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