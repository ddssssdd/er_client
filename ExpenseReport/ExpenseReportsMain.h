//
//  ExpenseReportsMain.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReportsViewController.h"
#import "ExpenseController.h"
#import "ProfileController.h"
#import "ServiceViewController.h"

@interface ExpenseReportsMain : NSObject
@property (nonatomic) ReportsViewController *reports;
@property (nonatomic) ExpenseController *expense;
@property (nonatomic) ProfileController *profile;
@property (nonatomic) ServiceViewController *services;
-(NSArray *)createControllers;

@end
