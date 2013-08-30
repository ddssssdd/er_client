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
#import "BaseTableViewController.h"
@interface ProfileController ()<UIAlertViewDelegate>{
    id _list;
    id _sectionList;
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
    if (_sectionList==nil){
        _sectionList =[[NSMutableArray alloc] init];
    }else{
        [_sectionList removeAllObjects];
    }

    id relocatee_list = [[AppSettings sharedSettings] loadJsonBy:RELOCATEE_LIST];
    if (relocatee_list){
        [_list addObject: relocatee_list];
        [_sectionList addObject:@{@"title":@"Relocatee List",@"image":@"",@"detail":@"RelocateeViewController"}];
    }
    id reports_list =[[AppSettings sharedSettings] loadJsonBy:EXPENSEREPORT_LIST];
    if (reports_list){
        [_list addObject:reports_list];
        [_sectionList addObject:@{@"title":@"Reports summary",@"image":@"title",@"detail":@""}];
    }
    id expense_list =[[AppSettings sharedSettings] loadJsonBy:EXPENSE_SUMMARY_LIST];
    if (expense_list){
        [_list addObject:expense_list];
        [_sectionList addObject:@{@"title":@"Expense summary",@"image":@"icon",@"detail":@""}];
    }
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
    cell.textLabel.text=item[@"key"];
    cell.detailTextLabel.text = item[@"value"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
    if (indexPath.section==0){
        
        if ([AppSettings sharedSettings].relocateeId==[item[@"value"] intValue]){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if ([[_sectionList objectAtIndex:indexPath.section][@"image"] isEqualToString:@"icon"]){
        cell.imageView.image=[UIImage imageNamed:item[@"icon"]];
    }else if ([[_sectionList objectAtIndex:indexPath.section][@"image"] isEqualToString:@"title"]){
        cell.imageView.image=[UIImage imageNamed:item[@"icon"]];
    }
    
    return cell;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HeaderView *view =[[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [view initWithTitleAndIcon:[_sectionList objectAtIndex:section][@"title"] imageName:nil];
    return  view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FooterView *view = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];
    
    return view;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id nav =[_sectionList objectAtIndex:indexPath.section];
    id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (![nav[@"detail"] isEqualToString:@""]){
        
        BaseTableViewController *vc =[[NSClassFromString(nav[@"detail"]) alloc] initWithNibName:nav[@"detail"] bundle:nil];
        vc.data  = item;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}
@end
