//
//  PiggyBanksModel.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 2/23/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import Foundation
import UIKit

class PiggyBanksModel {
    
    private var total: Double = 0
    private var availFunds: Double = 0
    private var monthsArr = [[Bill]]()  // Array of Array<Bill>
    private let NUMBER_OF_MONTHS = 12
    private var billNames = [String]()
    private var currentBill: Bill!
    
    var managedObjectContext: NSManagedObjectContext

    init()
    {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedObjectContext = appDelegate.managedObjectContext!
        if let savedTotal = fetchTotal() {
            self.total = savedTotal
        }
        fetchSaves()
        getExistingBillNames()
        checkIfBillsAreDue()
        adjustPayable()
        payBills()
        calculateBills()
    }
    
    func fetchTotal() -> Double?
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let savedTotal = defaults.objectForKey("total") as? NSNumber {
            return savedTotal.doubleValue
        }
        return nil
    }
    
    func saveTotal()
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(NSNumber(double: total), forKey: "total")
    }
    
    func fetchSaves()
    {
        let fetchRequest = NSFetchRequest(entityName: "Bill")
        
        var error: NSError?
        
        if let fetchedResults = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as? [Bill] {
            if fetchedResults.count > 0 {
                sortResults(fetchedResults)
            } else {
                println("No Saved Bills in CoreData. Creating Sample.")
                createSample()
            }
        } else {
            println("Error fetching \(error), \(error!.userInfo)")
        }
    }
    
    func createSample()
    {
        addBill("Sample Bill", owed: 100.00, day: getTodaysDate().day + 1, cushion: 1)
    }
    
    //Sort the saved bills from CoreData by month,date,name, and then amount owed. Each month of sorted bills is added to monthsArr.
    func sortResults(saves: [Bill])
    {
        monthsArr = []
        var arr = [Bill]()
        for monthIndex in 1...NUMBER_OF_MONTHS {
            arr = saves.filter() {$0.month == Int32(monthIndex)}
            arr = sorted(arr) { (billA: Bill, billB: Bill) -> Bool in
                if billA.day < billB.day {
                    return true
                } else if billA.day == billB.day {
                    if billA.name.lowercaseString < billB.name.lowercaseString {
                        return true
                    } else if billA.name.lowercaseString == billB.name.lowercaseString {
                        if billA.owed > billB.owed {
                            return true
                        }
                    }
                }
                return false
            }
            monthsArr.append(arr)
        }
        //Remove previous months and append to end of monthsArr
        let monthIndex = getTodaysDate().month - 1
        if monthIndex > 0 {
            var pastMonths = monthsArr[0..<monthIndex]
            pastMonths = resetBills(pastMonths)
            monthsArr.removeRange(0..<monthIndex)
            monthsArr += pastMonths
        }
    }
    
    func resetBills(pastMonths: ArraySlice<([(Bill)])>) -> ArraySlice<([(Bill)])>
    {
        for month in pastMonths {
            for billIndex in 0..<month.count {
                month[billIndex].balance = 0
                month[billIndex].isDue = false
                month[billIndex].isPaid = false
                month[billIndex].isPayable = false
            }
        }
        return pastMonths
    }
    
    func getExistingBillNames()
    {
        for bill in monthsArr[0] {
            billNames.append(bill.name)
        }
    }
    
    //mark all bills in mastermonth due to be paid
    func checkIfBillsAreDue()
    {
        let today = getTodaysDate().day
        let billsCheckedIfDue = monthsArr[0].map { (var bill: Bill) -> Bill in
            let day = bill.day
            if today >= Int(day) {
                bill.isDue = true
            } else {
                bill.isDue = false
            }
            return bill
        }
        monthsArr[0] = billsCheckedIfDue
    }
    
    func payBills()
    {
        monthsArr[0] = monthsArr[0].map { (bill: Bill) -> Bill in
            if bill.isDue && !bill.isPaid {
                bill.isPayable = false
                if bill.balance == bill.owed {
                    self.total -= bill.owed
                    bill.isPaid = true
                } else {
                    bill.balance = 0
                }
            }
            return bill
        }
    }
    
    private func adjustPayable()
    {
        //for every bill in month
        for billIndex in 0..<monthsArr[0].count {
            //get bill from current month
            let masterBill = monthsArr[0][billIndex]
            for monthIndex in 0..<monthsArr.count {
                if Int(masterBill.cushion) >= monthIndex {
                    if !monthsArr[monthIndex][billIndex].isDue {
                        monthsArr[monthIndex][billIndex].isPayable = true
                    }
                } else {
                    monthsArr[monthIndex][billIndex].isPayable = false
                }
            }
        }
    }
    
    func getTodaysDate() -> (month: Int, day: Int, year: Int)
    {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components(NSCalendarUnit.CalendarUnitMonth | NSCalendarUnit.CalendarUnitDay | NSCalendarUnit.CalendarUnitYear, fromDate: date)
        let month = components.month
        let day = components.day
        let year = components.year
        return (month, day, year)
    }
    
    private func calculateBills()
    {
        currentBill = monthsArr[0][0]
        var workingTotal = total
        //check each month in monthArr to see if is payable
        for monthIndex in 0..<monthsArr.count {
            for billIndex in 0..<monthsArr[0].count {
                var bill = monthsArr[monthIndex][billIndex]
                if bill.isPayable && !bill.isPaid {
                    if workingTotal >= bill.owed {
                        bill.balance = bill.owed
                        workingTotal -= bill.balance
                    } else {
                        bill.balance = workingTotal
                        workingTotal = 0
                        currentBill = bill
                    }
                    monthsArr[monthIndex][billIndex] = bill
                }
            }
        }
        availFunds = workingTotal
    }
    
    func moveBill(#fromIndex: Int, toIndex: Int)
    {
        for monthIndex in 0..<monthsArr.count {
            let movingBank = monthsArr[monthIndex].removeAtIndex(fromIndex)
            monthsArr[monthIndex].insert(movingBank, atIndex: toIndex)
        }
        updateModel()
    }
    
    func getTotal() -> Double
    {
        return total
    }
    
    func getAvailFunds() -> Double
    {
        return availFunds
    }
    
    func deleteBill(index: Int)
    {
        //must delete bill from coreData then rebuild monthsArray, else if monthsArray is in different order, wrong bills will be erased.
        for monthIndex in 0..<monthsArr.count {
            let bill = monthsArr[monthIndex].removeAtIndex(index)
            managedObjectContext.deleteObject(bill)
        }
        updateModel()
    }
    
    func updateModel()
    {
        adjustPayable()
        checkIfBillsAreDue()
        calculateBills()
        save()
    }
    
    func updateBill(bill oldName: String, newName: String, owed: Double, date: Int, cushion: Int)
    {
        let fetchRequest = NSFetchRequest(entityName: "Bill")
        fetchRequest.predicate = NSPredicate(format: "name == %@", oldName)
        
        var error: NSError?
        
        let fetchedResults = self.managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [Bill]?
        
        if let results = fetchedResults {
            results.map { (bill: Bill) -> Bill in
                bill.name = newName
                bill.owed = owed
                bill.day = Int32(date)
                bill.cushion = Int32(cushion)
                return bill
            }
            updateModel()
        } else {
            println("Error fetching \(error), \(error!.userInfo)")
        }
    }
    
    func deposit(amount: Double)
    {
        total += amount
        saveTotal()
        calculateBills()
    }
    
    //Never called
    func withdraw(amount: Double)
    {
        deposit(-amount)
    }
    
    func addBill(name: String, owed: Double, day: Int, cushion: Int)
    {
        billNames.append(name)
        for monthIndex in 1...NUMBER_OF_MONTHS {
            let bill = Bill.createInManagedObjectContext(managedObjectContext, name: name, owed: owed, date: (month: monthIndex, day: day), cushion: cushion)
            if bill.day < Int32(getTodaysDate().day) && monthIndex == getTodaysDate().month {
                bill.isDue = true
            }
        }
        fetchSaves()
        updateModel()
    }
    
    func doesBillNameAlreadyExist(name: String) -> Bool
    {
        for existingName in billNames {
            if existingName.lowercaseString == name.lowercaseString {
                return true
            }
        }
        return false
    }
    
    func save()
    {
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println(error?.localizedDescription)
        }
    }
    
    func getBillAt(#sectionIndex: Int, rowIndex: Int) -> Bill?
    {
        return monthsArr[sectionIndex][rowIndex]
    }
    
    func numberOfBills(index: Int) -> Int
    {
        return monthsArr[index].count
    }
    
    func getNumberOfMonths() -> Int?
    {
        return monthsArr.count
    }
    
}