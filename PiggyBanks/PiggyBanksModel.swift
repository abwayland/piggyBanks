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
    private var pbArray: [PiggyBank]
    private var total: Double
    private var availFunds: Double

    init() {
        pbArray = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 0
        }
        availFunds = total
        if let oldPBArray = defaults.objectForKey("pbArray") as? [PiggyBank] {
            pbArray = oldPBArray
        }
        calculate()
    }
    
    private func storeBanks() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(total, forKey: "total")
        defaults.setObject(pbArray, forKey: "pbArray")
        defaults.synchronize()
    }
    
    private func calculate() {
        var workingTotal = total
        for (index, bank) in enumerate(pbArray) {
            var mutBank = bank
            if let owedString = bank["owed"] {
                if let owed = NSNumberFormatter().numberFromString(owedString)?.doubleValue {
                    var paid: Double
                    if workingTotal > owed {
                        paid = owed
                        workingTotal -= owed
                    } else {
                        paid = workingTotal
                        workingTotal = 0
                    }
                    availFunds = workingTotal
                    mutBank["paid"] = "\(paid)"
                    pbArray[index] = mutBank
                }
            }
        }
    }
    
    func moveBank(#fromIndex: Int, toIndex: Int) {
        let movingBank = pbArray.removeAtIndex(fromIndex)
        pbArray.insert(movingBank, atIndex: toIndex)
        calculate()
        storeBanks()
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAvailFunds() -> Double {
        return availFunds
    }
    
    func deleteBank(index: Int) {
        pbArray.removeAtIndex(index)
        calculate()
        storeBanks()
    }
    
    func replaceBankAtIndex(index: Int, withBank bank: PiggyBank) {
        pbArray[index] = bank
    }
    
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
        pbArray.append(bank)
        calculate()
        storeBanks()
    }
    
    func getBankAtIndex(index: Int) -> PiggyBank   {
        return pbArray[index]
    }
    
    func numberOfBanks() -> Int {
        return pbArray.count
    }
    
}