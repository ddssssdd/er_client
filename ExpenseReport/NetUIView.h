//
//  NetUIView.h
//  edZoneTeacher
//
//  Created by Steven Fu on 3/27/13.
//  Copyright (c) 2013 Steven Fu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpClientDelegate.h"
#import "HttpHelper.h"

@interface NetUIView : UIView<HttpClientDelegate>{
    HttpHelper *_helper;
}

-(void)initData;
-(void)dispose;
@end
