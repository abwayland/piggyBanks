//
//  PiggyBank.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

struct PiggyBank {
    
    var name: String
    var balance: Double
    var owed: Double
    var date: Int
    var payable: Bool
    var cushion: Int
    var isDue: Bool
    var paid: Bool {
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