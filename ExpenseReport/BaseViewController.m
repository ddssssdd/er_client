//
//  BaseViewController.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/28/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UIBarButtonItem *)createCustomNavButton:(NSString *)imageName action:(SEL)action{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *butImage = [[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [button setBackgroundImage:butImage forState:UIControlStateNormal];
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 48, 30);
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
