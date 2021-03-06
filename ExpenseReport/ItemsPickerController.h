//
//  ItemsPickerController.h
//  ExpenseReport
//
//  Created by Steven Fu on 7/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

@interface ItemsPickerController : BaseTableViewController
@property (nonatomic) NSString *key;
@property (nonatomic) int selected;
@property (nonatomic) NSString *fieldName;

-(id)initWithList:(NSArray *)list;
@end
