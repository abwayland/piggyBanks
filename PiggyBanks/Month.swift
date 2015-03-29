//
//  Month.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/29/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation
import CoreData

class Month: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var number: Int16
    @NSManaged var bill: NSSet

}
