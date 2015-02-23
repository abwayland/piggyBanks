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
    private var PBArray: [PiggyBank]
    
    func addBank(bank: PiggyBank)
    {
        PBArray.append(bank)
    }
    
    func removeBank(bank: PiggyBank)
    {
        for (index, pig) in enumerate(PBArray) {
            if pig.name == bank.name {
                PBArray.removeAtIndex(index)
            }
        }
        
    }
    
    func getBankAtIndex(index: Int) -> PiggyBank
    {
        return PBArray[index]
    }
    
    func numberOfBanks() -> Int
    {
        return countElements(PBArray)
    }
    
    init()
    {
        PBArray = [PiggyBank]()
        let bank = PiggyBank(name: "test", amount: "100.00", date: "05.28.2015")
        addBank(bank)
    }
    
}