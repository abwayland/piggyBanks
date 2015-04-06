//
//  Bill.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/30/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation
import CoreData

class Bill: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var balance: Double
    @NSManaged var owed: Double
    @NSManaged var month: Int32
    @NSManaged var day: Int32
    @NSManaged var cushion: Int32
    @NSManaged var isDue: Bool
    @NSManaged var isPaid: Bool
    @NSManaged var isPayable: Bool
    @NSManaged var unique: String
    
    class func createInManagedObjectContext(moc: NSManagedObjectContext, name: String, owed: Double, date: (month: Int, day: Int), cushion: Int) -> Bill
    {
        let newBill = NSEntityDescription.insertNewObjectForEntityForName("Bill", inManagedObjectContext: moc) as Bill
        newBill.name = name
        newBill.owed = owed
        newBill.balance = 0
        newBill.month = Int32(date.month)
        newBill.day = Int32(date.day)
        newBill.cushion = Int32(cushion)
        newBill.isDue = false
        newBill.isPaid = false
        newBill.isPayable = false
        newBill.unique = name + "\(date.month)"
        return newBill
    }

}
