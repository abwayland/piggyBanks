//
//  PiggyBank.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation

struct PiggyBank {
    
    var name: String?
    var amount: String?
    var date: String?
    
    func getNSDic() -> NSDictionary
    {
        var dic = NSMutableDictionary()
        dic.setValue("name", forKey: name!)
        dic.setValue("amount", forKey: amount!)
        dic.setValue("date", forKey: date!)
        return dic
    }
    
}