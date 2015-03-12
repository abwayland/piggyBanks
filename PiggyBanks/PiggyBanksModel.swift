//
//  PiggyBanksModel.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

class PiggyBanksModel {
    
    //array of piggy banks
    private var PBArray: Array<[String:String]>
    private var total: Double
    private var availFunds: Double

    init() {
        PBArray = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 0
        }
        availFunds = total
        if let oldPBArray = defaults.objectForKey("PBArray") as? Array<[String:String]> {
            PBArray = oldPBArray
        }
        calculate()
    }
    
    private func storeBank() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(total, forKey: "total")
        defaults.setObject(PBArray, forKey: "PBArray")
        defaults.synchronize()
    }
    
    private func calculate() {
        var workingTotal = total
        for (index, bank) in enumerate(PBArray) {
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
                    PBArray[index] = mutBank
                }
            }
        }
    }
    
    func getTotal() -> Double {
        return total
    }
    
    func getAvailFunds() -> Double {
        return availFunds
    }
    
    func deleteBank(index: Int) {
        
    }
    
    func deposit(amount: Double) {
        total += amount
        calculate()
        storeBank()
    }
    
    func withdraw(amount: Double) {
        total -= amount
        calculate()
        storeBank()
    }
    
    func addBank(bank: [String:String]) {
        PBArray.append(bank)
        calculate()
        storeBank()
    }
    
    func getBankAtIndex(index: Int) -> [String : String]    {
        return PBArray[index]
    }
    
    func numberOfBanks() -> Int {
        return PBArray.count
    }
    
}