//
//  PiggyBank.h
//  PiggyBanks
//
//  Created by Adam Wayland on 3/26/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PiggyBank : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic) double balance;
@property (nonatomic) double owed;
@property (nonatomic) int16_t date;
@property (nonatomic) BOOL isPayable;
@property (nonatomic) int16_t cushion;
@property (nonatomic) BOOL isDue;
@property (nonatomic) BOOL isPaid;

@end
