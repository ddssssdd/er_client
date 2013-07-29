//
//  ExpenseReportsMain.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ExpenseReportsMain.h"


@implementation ExpenseReportsMain


-(NSArray *)createControllers{
    self.reports =[[ReportsViewController alloc] initWithNibName:@"ReportsViewController" bundle:nil];
    self.expense = [[ExpenseController alloc] initWithNibName:@"ExpenseController" bundle:nil];
    self.expense.title = @"Expense";
    self.expense.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Expense" image:[UIImage imageNamed:@"0099"] tag:0];
    
    self.profile = [[ProfileController alloc] initWithNibName:@"ProfileController" bundle:nil];
    
    self.profile.title = @"Profile";
    self.profile.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"0012"] tag:0];
    
    
    return @[[[UINavigationController alloc] initWithRootViewController:self.reports],
    [[UINavigationController alloc] initWithRootViewController:self.expense],
    [[UINavigationController alloc] initWithRootViewController: self.profile]];
}

@end
