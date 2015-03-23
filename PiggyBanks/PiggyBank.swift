//
//  PiggyBank.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

class PiggyBank {
    
    let name: String
    let balance: Double
    let owed: Double
    let date: Int
    let payable: Bool
    let cushion: Int
    let isDue: Bool
    let paid: Bool {
        get {
            if balance < owed {
                return false
            }
            return true
        }
    }
    
    init(name: String, owed: Double, date: Int)
    {
        self.name = name
        self.owed = owed
        self.date = date
        
        balance = 0
        payable = false
        isDue = false
        cushion = 0
    }
    
}