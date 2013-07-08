//
//  NetUIView.m
//  edZoneTeacher
//
//  Created by Steven Fu on 3/27/13.
//  Copyright (c) 2013 Steven Fu. All rights reserved.
//

#import "NetUIView.h"

@interface NetUIView(){
    
}
@end
@implementation NetUIView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(id)init{
    self = [super init];
    if (self){
        _helper =[[HttpHelper alloc] initWithTarget:self];
    }
    return self;
    
}
-(void)initData{
    if (!_helper){
        _helper =[[HttpHelper alloc] initWithTarget:self];
    }
    [_helper loadData];
    
}
-(void)setup{
    
}
-(void)processData:(id)json{
    
}
-(void)dispose{
    
}
@end
