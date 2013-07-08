//
//  HttpHelper.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClientDelegate.h"
#import "HttpClient.h"
#import "AppSettings.h"

@interface HttpHelper : NSObject


@property (nonatomic,copy) NSString *url;
@property (nonatomic,retain) id<HttpClientDelegate> delegate;

-(id)initWithTarget:(id<HttpClientDelegate>)target;



-(void)loadData;
-(void)restoreData;
-(HttpClient *)httpClient;
-(AppSettings *)appSetttings;

@end
