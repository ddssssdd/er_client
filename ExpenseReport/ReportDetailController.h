//
//  ReportDetailController.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
@interface ReportDetailController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtBegin;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
@property (weak, nonatomic) IBOutlet UITextField *txtPeopleCovered;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak,nonatomic) ERReport *report;
@end
