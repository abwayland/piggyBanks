//
//  Bill.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/29/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation
import CoreData

class Bill: NSManagedObject {

    @NSManaged var balance: Double
    @NSManaged var cushion: Int16
    @NSManaged var date: Int16
    @NSManaged var isDue: Bool
    @NSManaged var isPaid: Bool
    @NSManaged var isPayable: Bool
    @NSManaged var name: String
    @NSManaged var owed: Double
    @NSManaged var unique: String
    @NSManaged var belongsTo: Month

}
