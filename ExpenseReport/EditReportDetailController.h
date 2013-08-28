//
//  EditReportDetailController.h
//  ExpenseReport
//
//  Created by Steven Fu on 7/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
#import "BaseTableViewController.h"
@interface EditReportDetailController : BaseTableViewController<UITextFieldDelegate>

@property (nonatomic) ERReport *report;
@property (nonatomic) ERReportDetail *detail;
@property (nonatomic) NSDate *beginDate;
@property (nonatomic) NSDate *endDate;

-(id)initWithReport:(ERReport *)report;

@end
