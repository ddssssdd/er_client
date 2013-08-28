//
//  FooterView.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)initView{
    //self.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"list_line_1"]];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_line_1"]];
    [image setFrame:CGRectMake(0, 10, 320, 2)];
    [self addSubview:image];
}
@end
