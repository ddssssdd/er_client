//
//  ProfileController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ProfileController.h"

@interface ProfileController (){
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
    [[AppSettings sharedSettings] logout];
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
    }else if (indexPath.section==2){
        cell.textLabel.text=item[@"key"];
        cell.detailTextLabel.text = item[@"value"];
    }
    return cell;
    
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}
@end
