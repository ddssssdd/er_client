//
//  ReportCell.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblName;


@property (weak, nonatomic) IBOutlet UILabel *lblReportDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPeriodBegin;

@property (weak, nonatomic) IBOutlet UILabel *lblPeriodEnd;

-(id)initWithNib;
@end
