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
    NSDate *_tempDate;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    if ([self.currentDate isEqualToString:@""]){
        _tempDate = [NSDate date];
    }else{
        
        

        _tempDate =[df dateFromString:self.currentDate];
    }
    CGFloat x = 20;
    if (![AppDevice isIphone]){
        x = ([AppDevice screenWidth]-20)/2;
    }
	datelabel = [[UILabel alloc] init];
    datelabel.frame = CGRectMake(x, 20, 300, 40);
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.textColor = [UIColor whiteColor];
    datelabel.font = [UIFont fontWithName:@"Verdana-Bold" size: 20.0];
    datelabel.textAlignment = NSTextAlignmentCenter;
    
    


    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:_tempDate]];

    [self.view addSubview:datelabel];
    
    
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(x-20, 70, 325, 300)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    datePicker.date = _tempDate;
    
    [datePicker addTarget:self
                   action:@selector(LabelChange:)
         forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    self.navigationItem.leftBarButtonItem = [self createCustomNavButton:@"cancel_btn_out" action:@selector(backTo)];
    self.navigationItem.rightBarButtonItem = [self createCustomNavButton:@"done_btn_out" action:@selector(save)];
    
    
    
}
-(void)backTo{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
    [formmater setDateFormat:@"yyyy-MM-dd"];
    if (self.beginDate){
        
        if ([self.datePicker.date compare:self.beginDate]==NSOrderedAscending){
            [[[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:@"Expense Date must later than %@",[formmater stringFromDate:self.beginDate]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
            return;
        }
    }
    if (self.endDate){

        [formmater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        NSDate *current = [formmater dateFromString:[formmater stringFromDate:self.datePicker.date]];
        if ([current compare:self.endDate]==NSOrderedDescending){
            [[[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:@"Expense Date must earlier than %@",[formmater stringFromDate:self.endDate]] delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles: nil] show];
            return;
            
        }
    
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHOOSE_DATE object:nil userInfo:@{@"value":self.datelabel.text,@"key":self.key}];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)LabelChange:(id)sender{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //df.dateStyle = NSDateFormatterMediumStyle;
    df.dateFormat = @"yyyy-MM-dd";
    datelabel.text = [NSString stringWithFormat:@"%@",
                      [df stringFromDate:datePicker.date]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
