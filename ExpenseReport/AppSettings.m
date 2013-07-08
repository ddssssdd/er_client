//
//  AppSettings.m
//  Learn ActivityViewController
//
//  Created by Fu Steven on 1/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "AppSettings.h"
#import "UIImageView+AFNetworking.h"


@implementation AppSettings

@synthesize isLogin = _isLogin;
@synthesize userid=_userid;
@synthesize list = _list;
@synthesize user=_user;

@synthesize local_data =_local_data;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self =[super init];
    if (self)
    {
        _isLogin =[aDecoder decodeBoolForKey:@"isLogin"];
        _userid =[aDecoder decodeInt32ForKey:@"userid"];
        _list =[aDecoder decodeObjectForKey:@"list"];
        _user =[aDecoder decodeObjectForKey:@"user"];
        _local_data =[aDecoder decodeObjectForKey:@"local_data"];
        _dict = [[NSMutableDictionary  alloc] init];
       
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeBool:_isLogin forKey:@"isLogin"];
    [aCoder encodeInt32:_userid forKey:@"userid"];
    [aCoder encodeObject:_list forKey:@"list"];
    [aCoder encodeObject:_user forKey:@"user"];
    [aCoder encodeObject:_local_data forKey:@"local_data"];
}

-(id)init{
    self = [super init];
    if (self){
        _dict = [[NSMutableDictionary  alloc] init];
       
    }
    return self;
}

+(AppSettings *)sharedSettings
{
    static AppSettings *_instance;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        //_instance = [[AppSettings alloc] init];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSData *userDefaultData =[userDefault objectForKey:NSStringFromClass([self class])];
        if (userDefaultData){
            _instance =[NSKeyedUnarchiver unarchiveObjectWithData:userDefaultData];
        }else{
            _instance =[[AppSettings alloc] init];
        }
        [_instance init_data];
        
    });
    return _instance;
}

-(void)init_data{
   
}
- (void)save{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSData *udObject = [NSKeyedArchiver archivedDataWithRootObject:self];
    [userDefault setObject:udObject forKey:NSStringFromClass([self class])];
    [userDefault synchronize];
    
}
//local data process
-(void)saveJsonWithKey:(NSString *)key data:(id)data{
    if (!_local_data){
        _local_data =[[NSMutableDictionary alloc] init];
        
    }
    id item =@{@"date" : [NSDate date],@"data":data};
    [_local_data setObject:item forKey:key];
    [self save];
    
}
-(id)loadJsonByKey:(NSString *)key{
    if (_local_data){
        return [[_local_data objectForKey:key] objectForKey:@"data"];
    }else{
        return nil;
    }
}

-(void)saveJsonWith:(NSString *)className data:(id)data{
    if (!_local_data){
        _local_data =[[NSMutableDictionary alloc] init];
        
    }
    id item =@{@"date" : [NSDate date],@"data":data};
    [_local_data setObject:item forKey:[self jsonKey:className]];
    [self save];

}
-(id)loadJsonBy:(NSString *)className{
    if (_local_data){
        return [[_local_data objectForKey:[self jsonKey:className]] objectForKey:@"data"];
    }else{
        return nil;
    }
}
-(NSString *)jsonKey:(NSString *)className{
    return [NSString stringWithFormat:@"%@_by_%d",className,self.userid];
}


//http process
-(BOOL)isSuccess:(id)json
{
    NSString *status =json[@"status"];
    return [status boolValue];
}

-(HttpClient *)http{
    return [HttpClient sharedHttp];
}
-(AppDict *)dict{
    return [AppDict sharedDict];
}
-(void)login:(id)relocatee{
    self.user = relocatee;
    self.isLogin = YES;
    self.userid = [relocatee[@"RelocateeID"] intValue];

    [self save];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LOGIN object:nil];
    //[self load_init_data];
}
-(void)logout{
    self.user = nil;
    self.userid = 0;
    self.isLogin = NO;
    [self save];
    [[NSNotificationCenter defaultCenter] postNotificationName:EVENT_LOGOUT object:nil];
}


-(void)load_init_data{
    NSString *url = @"ExpenseReports/reportStatus";
    [self.http get:url block:^(id json) {
        if ([self isSuccess:json]){
            [self saveJsonWithKey:REPORTSTATUS data:json[@"result"]];
        }
    }];
    
}
-(id)reportstatus{
    return [self loadJsonByKey:REPORTSTATUS];
}

-(NSString *)getString:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]){
        return @"";
    }else{
        return [NSString stringWithFormat:@"%@",obj];
    }
         
}
-(NSString *)getDateString:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]){
        return @"";
    }else{
        return [[NSString stringWithFormat:@"%@",obj] substringToIndex:10];
    }
    
}
-(float)getFloat:(id)obj{
    if ([obj isKindOfClass:[NSNull class]]){
        return 0.0f;
    }else{
        return [obj floatValue];
    }
}
@end
