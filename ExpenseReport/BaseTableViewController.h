//
//  BaseTableViewController.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController{
    id _list;
}
-(UIBarButtonItem *)createCustomNavButton:(NSString *)imageName action:(SEL)action;
@property (nonatomic) id data;
-(NSString *)getHeaderTitle:(int)section;
@end
