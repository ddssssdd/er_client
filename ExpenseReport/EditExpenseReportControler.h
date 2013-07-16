//
//  EditExpenseReportControler.h
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"

@interface EditExpenseReportControler : UITableViewController<UITextFieldDelegate>
@property (nonatomic) ERReport *report;

@end
