//
//  AppHelper.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/29/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppHelper : NSObject


+(NSString *)dateToString:(NSDate *)date;
+(NSDate *)stringToDate:(NSString *)string;


+(UIBarButtonItem *)createCustomNavButton:(NSString *)imageName action:(SEL)action;
+(UIImage *)addImage;
+(UIImage *)editImage;
+(UIImage *)removeImage;
@end
