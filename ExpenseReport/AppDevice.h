//
//  AppDevice.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppDevice : NSObject
+(BOOL)isIphone;
+(float)screenWidth;
+(float)screenHeight;
+(NSString *)getNibName:(NSString *)xib;
+(NSString *)dateToString:(NSDate *)date;
+(NSDate *)stringToDate:(NSString *)string;
@end
