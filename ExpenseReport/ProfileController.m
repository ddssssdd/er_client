//
//  ProfileController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProfileController.h"
#import "HeaderView.h"
#import "FooterView.h"
@interface ProfileController ()<UIAlertViewDelegate>{
    id _list;
}

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
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStyleDone  target:self action:@selector(logout)];
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)logout{
    [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Are you sure to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil] show];

}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
            [[AppSettings sharedSettings] logout];
    }
}
-(void)initData{
    if (_list==nil){
        _list = [[NSMutableArray alloc] init];
    }else{
        [_list removeAllObjects];
    }
    id relocatee_list = [[AppSettings sharedSettings] loadJsonBy:RELOCATEE_LIST];
    if (relocatee_list)
        [_list addObject: relocatee_list];
    [_list addObject:[[AppSettings sharedSettings] loadJsonBy:EXPENSEREPORT_LIST]];
    [_list addObject:[[AppSettings sharedSettings] loadJsonBy:EXPENSE_SUMMARY_LIST]];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    
    //set cell;
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    //NSLog(@"%@",item);
    if (indexPath.section==0){
        cell.textLabel.text = item[@"FirstName"];
        if ([AppSettings sharedSettings].relocateeId==[item[@"RelocateeID"] intValue]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }else if (indexPath.section==1){
        cell.textLabel.text = item[@"status"][@"Description"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",[item[@"list"] count]];
        NSString *imageName = [[[[cell.textLabel.text stringByReplacingOccurrencesOfString:@" " withString:@"_"] lowercaseString] stringByAppendingString:@"_list"] stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
        cell.imageView.image=[UIImage imageNamed:imageName] ;
    }else if (indexPath.section==2){
        cell.textLabel.text=item[@"key"];
        cell.detailTextLabel.text = item[@"value"];
        cell.imageView.image=[UIImage imageNamed:item[@"icon"]];
    }
    
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView *view =[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (section==0){
        [view initWithTitleAndIcon:@"Relocatee List" imageName:nil];
    }else if (section==1){
        [view initWithTitleAndIcon:@"Reports summary" imageName:nil];
    }else{
        [view initWithTitleAndIcon:@"Expense summary" imageName:nil];
    }
    return  view;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0){
        return @"Relocatee List";
    }else if (section==1){
        return @"Reports summary";
    }else{
        return @"Expense summary";
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FooterView *view = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
