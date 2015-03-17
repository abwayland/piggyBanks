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
    private var yearArray = [[PiggyBank]]()  // Array of Array<PiggyBank>
    private var numberOfMonths = 3

    init()
    {
        //get number of months to display
        //create pbArray
        var monthArray = [PiggyBank]()
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 0
        }
        availFunds = total
        if let oldPBArray = defaults.objectForKey("pbArray") as? [PiggyBank] {
            monthArray = oldPBArray
        } else {
            monthArray = createSamples()
        }
        //fill monthArray with pbArrays
        for var i = 0; i < numberOfMonths; i++ {
            yearArray.append(monthArray)
        }
        adjustPayable()
        calculate()
    }
    
    func createSamples() -> [PiggyBank]
    {
        let samp1: PiggyBank = ["name":"Some Bill","owed":"100","date":"1","payable":"no","cushion":"2"]
        let samp2: PiggyBank = ["name":"Another Bill","owed":"50","date":"15","payable":"no", "cushion":"2"]
        let samp3: PiggyBank = ["name":"Yet Another Bill","owed":"25","date":"30","payable":"no","cushion":"0"]
        return [samp1,samp2,samp3]
    }
    
    private func storeBanks() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(total, forKey: "total")
        defaults.setObject(yearArray, forKey: "pbArray")
        defaults.synchronize()
    }
    
    private func adjustPayable()
    {
        // All bills in current month are marked payable
        var currentMonth = yearArray[0]
        for index in 0..<currentMonth.count {
            currentMonth[index]["payable"] = "yes"
            //check cushion and mark eligible bills as payable
            let cushion = currentMonth[index]["cushion"]
            if cushion != nil {
                let cushionInt = NSNumberFormatter().numberFromString(cushion!)?.integerValue
                if cushionInt != nil {
                    for indexB in 0...cushionInt! {
                        yearArray[indexB][index]["payable"] = "yes"
                    }
                }
            }
        }
        yearArray[0] = currentMonth
    }
    
    private func calculate() {
        var workingTotal = total
        var mutYearArray = yearArray
        //check each month in yearArray to see if is payable
        for (yIndex, month) in enumerate(yearArray) {
            for (mIndex, bank) in enumerate(month) {
                var mutBank = bank
                if let owedString = bank["owed"] {
                    if let owed = NSNumberFormatter().numberFromString(owedString)?.doubleValue {
                        var paid = 0.0
                        if let payable = bank["payable"] {
                            // if it is payable work bill into calculation
                            if payable == "yes" {
                                //if workingTotal is greater than what is owed, pay bill, subtract owed from workingTotal
                                if workingTotal > owed {
                                    paid = owed
                                    workingTotal -= owed
                                //else add whatever is left to bill, working total is now zero
                                } else {
                                    paid = workingTotal
                                    workingTotal = 0
                                }
                            }
                        }
                        //whatever the working total equals is what you have left to spend
                        availFunds = workingTotal
                        //bank key "paid" is updated
                        mutBank["paid"] = "\(paid)"
                        //mutable copy of the yearArray is updated with mutated bank
                        mutYearArray[yIndex][mIndex] = mutBank
                    }
                }
            }
        }
        //year Array is replaced with mutated year array
        yearArray = mutYearArray
    }
    
//    func moveBank(#fromIndex: Int, toIndex: Int) {
//        let movingBank = pbArray!.removeAtIndex(fromIndex)
//        pbArray!.insert(movingBank, atIndex: toIndex)
//        calculate()
//        storeBanks()
//    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAvailFunds() -> Double {
        return availFunds
    }
    
//    func deleteBank(index: Int) {
//        pbArray?.removeAtIndex(index)
//        calculate()
//        storeBanks()
//    }
    
//    func replaceBankAtIndex(index: Int, withBank bank: PiggyBank) {
//        pbArray?[index] = bank
//    }
    
    func deposit(amount: Double) {
        total += amount
        calculate()
        storeBanks()
    }
    
    func withdraw(amount: Double) {
        total -= amount
        calculate()
        storeBanks()
    }
    
    func addBank(bank: PiggyBank) {
        var mutYearArray = yearArray
        for (index, month) in enumerate(yearArray) {
            mutYearArray[index].append(bank)
        }
        yearArray = mutYearArray
        calculate()
        storeBanks()
    }
    
    func getBankAt(#sectionIndex: Int, rowIndex: Int) -> PiggyBank?   {
        return yearArray[sectionIndex][rowIndex]
    }
    
    func numberOfBanks() -> Int {
        return yearArray[0].count
    }
    
    func getNumberOfMonths() -> Int? {
        return yearArray.count
    }
    
}