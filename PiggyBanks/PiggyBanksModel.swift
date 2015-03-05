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
    
    init()
    {
        PBArray = []
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults
        if let oldTotal = defaults.objectForKey("total") as? NSNumber {
            total = oldTotal.doubleValue
        } else {
            total = 100
        }
        if let oldPBArray = defaults.objectForKey("PBArray") as? Array<[String:String]> {
            PBArray = oldPBArray
        }
        calculate()
    }
    
    func calculate()
    {
        for (index, bank) in enumerate(PBArray) {
            var mutBank = bank
            if let owedString = bank["owed"] {
                let newOwedString = owedString.substringFromIndex(owedString.startIndex.successor())
                if let owed = NSNumberFormatter().numberFromString(newOwedString)?.doubleValue ?? 0.0 {
                    var paid: Double
                    if total > owed {
                        paid = owed
                        total -= owed
                    } else {
                        paid = total
                        total = 0
                    }
                    mutBank["paid"] = NSNumberFormatter.localizedStringFromNumber(paid, numberStyle: NSNumberFormatterStyle.CurrencyStyle)
                    PBArray[index] = mutBank
                }
            }
        }
    }
    
    func getTotal() -> Double
    {
        return total
    }
    
    func deposit(amount: Double)
    {
        total += amount
    }
    
    func withdraw(amount: Double)
    {
        total -= amount
    }
    
    func addBank(bank: [String:String])
    {
        PBArray.append(bank)
    }
    
    func getBankAtIndex(index: Int) -> [String : String]    {
        return PBArray[index]
    }
    
    func numberOfBanks() -> Int
    {
        return PBArray.count
    }
    
}