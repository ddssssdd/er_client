//
//  BaseViewController.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
-(UIBarButtonItem *)createCustomNavButton:(NSString *)imageName action:(SEL)action;
@end
