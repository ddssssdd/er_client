//
//  ReportCell.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ReportCell.h"

@implementation ReportCell

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
    self = [[[NSBundle mainBundle] loadNibNamed:@"ReportCell" owner:nil options:nil] objectAtIndex:0];
    return self;
}

@end
