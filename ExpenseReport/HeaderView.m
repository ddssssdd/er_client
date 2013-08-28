//
//  HeaderView.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
-(void)initWithTitle:(NSString *)title{
    NSString *imageName = [[[[title stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString] stringByAppendingString:@"_title"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    NSLog(@"%@",imageName);
    [self initWithTitleAndIcon:title imageName:imageName];

}
-(void)initWithTitleAndIcon:(NSString *)title imageName:(NSString *)imageName{
    if (!imageName){
        imageName = [[[title stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString] stringByAppendingString:@"_icon"];
    }
    self.backgroundColor = [UIColor clearColor];
    UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    [image setFrame:CGRectMake(20, 10, 21, 21)];
    [self addSubview:image];
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 21)];
    [label setFont:[UIFont systemFontOfSize:16]];
    [label setTextColor:[UIColor whiteColor]];
    label.text=title;
    label.backgroundColor = [UIColor clearColor];
    [self addSubview:label];
}
@end
