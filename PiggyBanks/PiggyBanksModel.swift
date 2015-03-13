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
    private var pBArray: Array<[String:String]>
    private var total: Double
    private var availFunds: Double

    init() {
        pBArray = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 0
        }
        availFunds = total
        if let oldPBArray = defaults.objectForKey("PBArray") as? Array<[String:String]> {
            pBArray = oldPBArray
        }
        calculate()
    }
    
    private func storeBanks() {
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(total, forKey: "total")
        defaults.setObject(pBArray, forKey: "PBArray")
        defaults.synchronize()
    }
    
    private func calculate() {
        var workingTotal = total
        for (index, bank) in enumerate(pBArray) {
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
                    pBArray[index] = mutBank
                }
            }
        }
    }
    
    func moveBank(#fromIndex: Int, toIndex: Int) {
        let movingBank = pBArray.removeAtIndex(fromIndex)
        pBArray.insert(movingBank, atIndex: toIndex)
        println("\(pBArray)")
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
        pBArray.removeAtIndex(index)
        calculate()
        storeBanks()
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
    
    func addBank(bank: [String:String]) {
        pBArray.append(bank)
        calculate()
        storeBanks()
    }
    
    func getBankAtIndex(index: Int) -> [String : String]    {
        return pBArray[index]
    }
    
    func numberOfBanks() -> Int {
        return pBArray.count
    }
    
}