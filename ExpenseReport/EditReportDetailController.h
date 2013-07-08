//
//  EditReportDetailController.h
//  ExpenseReport
//
//  Created by Steven Fu on 7/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
@interface EditReportDetailController : UITableViewController

@property (nonatomic) ERReport *report;
@property (nonatomic) ERReportDetail *detail;

-(id)initWithReport:(ERReport *)report;

@end
