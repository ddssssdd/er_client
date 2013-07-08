//
//  HttpClientDelegate.h
//  EasyDrive365
//
//  Created by Fu Steven on 2/17/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HttpClientDelegate <NSObject>


-(void)setup;

-(void)processData:(id)json;


@end
