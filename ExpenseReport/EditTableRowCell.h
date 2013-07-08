//
//  EditTableRowCell.h
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditTableRowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lable;
@property (weak, nonatomic) IBOutlet UITextField *text;

-(id)initWithNib;
@end
