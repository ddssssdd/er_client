//
//  AppSettings.h
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"
#import "AppDict.h"


@interface AppSettings : NSObject<NSCoding>{
    NSMutableDictionary *_dict;

    

}

@property (nonatomic) BOOL isLogin;
@property (nonatomic) int userid;
@property (nonatomic) int relocateeId;
@property (nonatomic) int personId;
@property (nonatomic,retain) id relocatee;

@property (nonatomic,retain) NSMutableDictionary *local_data;
@property (nonatomic,retain) NSMutableArray *list;
@property (nonatomic) NSString *token;



+(AppSettings *)sharedSettings;


-(void)save;

//local data process
-(void)saveJsonWith:(NSString *)className data:(id)data;
-(id)loadJsonBy:(NSString *)className;

//http process
-(BOOL)isSuccess:(id)json;


-(HttpClient *)http;
-(AppDict *)dict;

-(void)login:(id)relocatee userId:(int)userId personId:(int)personId;
-(void)logout;
-(void)load_init_data;

-(id)reportstatus;

-(NSString *)getString:(id)obj;
-(NSString *)getDateString:(id)obj;
-(float)getFloat:(id)obj;


-(void)registerDeviceToken:(NSString *)token;
-(BOOL)isIphone;
@end
