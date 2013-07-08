//
//  ReportDetailCell.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;

-(id)initWithNib;
@end
