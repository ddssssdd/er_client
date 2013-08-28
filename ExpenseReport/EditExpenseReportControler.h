//
//  EditExpenseReportControler.h
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
#import "BaseTableViewController.h"

@interface EditExpenseReportControler : BaseTableViewController<UITextFieldDelegate>
@property (nonatomic) ERReport *report;

@end
