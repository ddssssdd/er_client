//
//  RelocateeViewController.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/30/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "RelocateeViewController.h"

@interface RelocateeViewController ()

@end

@implementation RelocateeViewController

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

    self.title = [self.data[@"key"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    id item = [[_list objectAtIndex:indexPath.section][@"Items"] objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"Title"];
    [cell.textLabel setFont:[UIFont systemFontOfSize:12]];
    cell.detailTextLabel.text = item[@"Detail"];
    [cell.detailTextLabel setFont:[UIFont systemFontOfSize:10]];
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section][@"Title"];
}
-(void)loadData{
    NSString *url =[NSString stringWithFormat:@"Relocatee/index/%@",self.data[@"value"]];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            [self.tableView reloadData];

        }
    }];
}
@end
