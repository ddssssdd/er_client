//
//  DatePickerController.m
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController ()

@end

@implementation DatePickerController
@synthesize datelabel,datePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	datelabel = [[UILabel alloc] init];
    datelabel.frame = CGRectMake(10, 20, 300, 40);
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.textColor = [UIColor whiteColor];
    datelabel.font = [UIFont fontWithName:@"Verdana-Bold" size: 20.0];
    datelabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:[NSDate date]]];

    [self.view addSubview:datelabel];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 70, 325, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = [NSDate date];
    
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(save)];
    
    
    
}
-(void)save{
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHOOSE_DATE object:nil userInfo:@{@"value":self.datePicker.date}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateStyle = NSDateFormatterMediumStyle;
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
