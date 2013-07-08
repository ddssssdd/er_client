//
//  ProfileController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController ()

@end

@implementation ProfileController

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
    self.title = @"Profile";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:[UIImage imageNamed:@"0012"] tag:0];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone  target:self action:@selector(logout)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout{
    [[AppSettings sharedSettings] logout];
}

@end
