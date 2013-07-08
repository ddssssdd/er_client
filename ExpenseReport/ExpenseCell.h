//
//  ExpenseCell.h
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblPayee;

@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblNetcheck;

-(id)initWithNib;
@end
