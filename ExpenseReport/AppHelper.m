//
//  AppHelper.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppHelper.h"

@implementation AppHelper

+(UIBarButtonItem *)createCustomNavButton:(NSString *)imageName action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *butImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [button setBackgroundImage:butImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 48, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
+(NSString *)dateToString:(NSDate *)date{
    if (!date)
        return nil;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd" ];
    [formmater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formmater stringFromDate:date];
}
+(NSDate *)stringToDate:(NSString *)string{
    if ([string isEqualToString:@""])
        return nil;
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd" ];
    [formmater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [formmater dateFromString:string];
}
+(UIImage *)addImage{
    return [UIImage imageNamed:@"add_list"];
}
+(UIImage *)editImage{
    return [UIImage imageNamed:@"edit_list"];
}
+(UIImage *)removeImage{
    return [UIImage imageNamed:@"delete_list"];
}
@end
