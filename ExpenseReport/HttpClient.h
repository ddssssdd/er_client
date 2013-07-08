//
//  HttpClient.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/9/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject{
    
}
@property (nonatomic) BOOL isInternet;

+(HttpClient *)sharedHttp;

-(void)online;
-(void)get:(NSString *)path  block:(void (^)(id json))processJson;
-(void)post:(NSString *)path parameters:(NSDictionary *)parameters block:(void (^)(id json))processJson;
-(void)getJson:(NSString *)path  block:(void (^)(id json))processJson;



@end
