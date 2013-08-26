//
//  AppDevice.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppDevice.h"

@implementation AppDevice
+(BOOL)isIphone{
    return [[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPhone;
}
+(float)screenHeight{
    return [[UIScreen mainScreen] bounds].size.height;
}
+(float)screenWidth{
    return [[UIScreen mainScreen] bounds].size.width;
}
+(NSString *)getNibName:(NSString *)xib{
    return [NSString stringWithFormat:@"%@%@",xib,[AppDevice isIphone]?@"":@"_ipad"];
}
@end
