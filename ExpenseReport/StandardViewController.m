//
//  StandardViewController.m
//  ExpenseReport
//
//  Created by Steven Fu on 9/5/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "StandardViewController.h"

@interface StandardViewController ()

@end

@implementation StandardViewController

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
    return [[_list objectAtIndex:section][@"Items"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    id item = [[_list objectAtIndex:indexPath.section][@"Items"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"Title"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    cell.detailTextLabel.text =[[AppSettings sharedSettings] getString: item[@"Detail"]];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section][@"Title"];
}
-(void)loadData{


    [[AppSettings sharedSettings].http get:self.url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];
            
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    id item = [[_list objectAtIndex:indexPath.section][@"Items"] objectAtIndex:indexPath.row];
    if (item[@"Url"] && ![item[@"Url"] isEqualToString:@""]){
        StandardViewController *vc = [[StandardViewController alloc] initWithNibName:@"StandardViewController" bundle:nil];
        vc.url = item[@"Url"];
        vc.title = item[@"Title"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
