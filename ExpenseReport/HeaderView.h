//
//  HeaderView.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView


-(void)initWithTitle:(NSString *)title;
-(void)initWithTitleAndIcon:(NSString *)title imageName:(NSString *)imageName;
@end
