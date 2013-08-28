//
//  DatePickerController.h
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface DatePickerController : BaseViewController{
    IBOutlet UIDatePicker *datePicker;
    IBOutlet UILabel *datelabel;
}


@property(nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) IBOutlet UILabel *datelabel;
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *currentDate;

@property (nonatomic) NSDate *beginDate;
@property (nonatomic) NSDate *endDate;
@end
