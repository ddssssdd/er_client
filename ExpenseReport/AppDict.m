//
//  AppDict.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppDict.h"
#import "AppSettings.h"

@implementation AppDict
+(AppDict *)sharedDict{
    static AppDict *_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        _instance = [[AppDict alloc] init];
    });
    return _instance;
}

-(void)get_purposes:(void (^)(NSArray *list))callBack{
    NSArray *result = [[AppSettings sharedSettings] loadJsonBy:EXPENSEPURPOSE];
    if (result){
        if (callBack)
            callBack(result);
    }else{
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/purposes?relocateeId=%d",[AppSettings sharedSettings].relocateeId];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [[AppSettings sharedSettings] saveJsonWith:EXPENSEPURPOSE data:json[@"result"]];
                if (callBack)
                    callBack(json[@"result"]);
            }

        }];
        
    }
}
-(void)get_services:(void (^)(NSArray *list))callBack{
    NSArray *result = [[AppSettings sharedSettings] loadJsonBy:EXPENSESERVCIE];
    if (result){
        if (callBack)
            callBack(result);
    }else{
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/services?relocateeId=%d",[AppSettings sharedSettings].relocateeId];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [[AppSettings sharedSettings] saveJsonWith:EXPENSESERVCIE data:json[@"result"]];
                if (callBack)
                    callBack(json[@"result"]);
            }
            
        }];
        
    }
}
-(void)get_reportstatus:(void (^)(NSArray *list))callBack{
    NSArray *result = [[AppSettings sharedSettings] loadJsonBy:REPORTSTATUS];
    if (result){
        if (callBack)
            callBack(result);
    }else{
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/reportStatus"];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [[AppSettings sharedSettings] saveJsonWith:REPORTSTATUS data:json[@"result"]];
                if (callBack)
                    callBack(json[@"result"]);
            }
            
        }];
        
    }
}
@end
