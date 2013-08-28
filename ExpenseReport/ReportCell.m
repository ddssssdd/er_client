//
//  ReportCell.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ReportCell.h"
#import "AppDevice.h"

@implementation ReportCell

+(CGFloat)cellWidth{
    return [AppDevice isIphone]?55.0:44.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(id)initWithNib{
    NSString *nibName = @"ReportCell";
    if (![AppDevice isIphone]){
        nibName=@"ReportCell_ipad";
    }
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    //self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_titlebg"]];
    return self;
}

@end
