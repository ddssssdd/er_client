//
//  ServiceViewController.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ServiceViewController.h"

@interface ServiceViewController ()

@end

@implementation ServiceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Service";
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return [_list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_list objectAtIndex:section][@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    id item = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"Description"];
    cell.detailTextLabel.text = item[@"ServiceStatus"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section][@"name"];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

-(void)loadData{
    NSString *url = [NSString stringWithFormat:@"Relocatee/services/%d",[AppSettings sharedSettings].relocateeId];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (!_list){
                _list = [[NSMutableArray alloc] init];
            }else{
                [_list removeAllObjects];
            }
            
            for (id item in json[@"result"]) {
                id groupList;
                for (id group in _list) {
                    if ([group[@"name"] isEqualToString:item[@"GroupName"]]){
                        groupList = group;
                        break;
                    }
                }
                if (!groupList){
                    groupList = [[NSMutableDictionary alloc] init];
                    [groupList setObject:item[@"GroupName"] forKey:@"name"];
                    [groupList setObject:[[NSMutableArray alloc] init] forKey:@"list"];
                    [_list addObject:groupList];
                }
                [groupList[@"list"] addObject:item];
            }
            [self.tableView reloadData];
        }
    }];
}
@end
