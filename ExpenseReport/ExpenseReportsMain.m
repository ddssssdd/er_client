//
//  ExpenseReportsMain.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ExpenseReportsMain.h"
#import "ReportsViewController.h"
#import "ExpenseController.h"
#import "ProfileController.h"

@implementation ExpenseReportsMain


-(NSArray *)createControllers{
    ReportsViewController *reports =[[ReportsViewController alloc] initWithNibName:@"ReportsViewController" bundle:nil];
    ExpenseController *expense = [[ExpenseController alloc] initWithNibName:@"ExpenseController" bundle:nil];
    ProfileController *profile = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
    return @[[[UINavigationController alloc] initWithRootViewController:reports],
    [[UINavigationController alloc] initWithRootViewController:expense],
    [[UINavigationController alloc] initWithRootViewController: profile]];
}

@end
