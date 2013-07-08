//
//  AppDict.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDict : NSObject


+(AppDict *)sharedDict;


-(void)get_reportstatus:(void (^)(NSArray *list))callBack;
-(void)get_purposes:(void (^)(NSArray *list))callBack;
-(void)get_services:(void (^)(NSArray *list))callBack;
@end
