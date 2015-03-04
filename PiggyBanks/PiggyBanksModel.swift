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
    
    init()
    {
        PBArray = []
        let defaults = NSUserDefaults.standardUserDefaults()
        if let oldPBArray = defaults.objectForKey("PBArray") as? Array<[String:String]> {
            PBArray = oldPBArray
        } else {
            let bank = ["name" : "Sample", "amount" : "$0.00"]
            addBank(bank)
        }
    }
}