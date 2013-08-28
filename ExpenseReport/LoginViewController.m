//
//  LoginViewController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginRelocateeController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

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
- (IBAction)loginButtonPressed:(id)sender {
    NSString *url = [NSString stringWithFormat:@"users/login?username=%@&password=%@",self.txtUsername.text,self.txtPassword.text];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            LoginRelocateeController *vc = [[LoginRelocateeController alloc] initWithNibName:@"LoginRelocateeController" bundle:nil];
            [self.navigationController pushViewController:vc animated:YES];
            [vc loginWithPersonId:[json[@"result"][@"PersonID"] intValue] userId:[json[@"result"][@"PersonUserID"] intValue]];
        }
    }];
    
    
}

@end
