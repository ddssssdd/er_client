//
//  ExpenseController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ExpenseController.h"
#import "ExpenseCell.h"
#import "ERReport.h"

@interface ExpenseController (){
    id _list;
    id _summaryList;
}

@end

@implementation ExpenseController

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
    [self initData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0){
        return [_summaryList count];
    }else{
        return [_list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    if (indexPath.section==0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text=[_summaryList objectAtIndex:indexPath.row][@"key"];
        cell.detailTextLabel.text = [_summaryList objectAtIndex:indexPath.row][@"value"];
        return cell;
    }else{
        ExpenseCell *aCell = [[ExpenseCell alloc] initWithNib];
        ExpenseItem *item = [_list objectAtIndex:indexPath.row];
       
        aCell.lblDescription.text= item.description;
        aCell.lblDate.text = item.report_date;
        aCell.lblPayee.text = item.paidto;
        aCell.lblAmount.text =[NSString stringWithFormat:@"%1.2fUSD", item.amount];
        aCell.lblNetcheck.text =[NSString stringWithFormat:@"%1.2fUSD", item.netcheck];
        return aCell;
        
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        return 44.0f;
    }else{
        return 50.0f;
    }
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
-(void)initData{
    NSString *url =[NSString stringWithFormat:@"ExpenseReports/expense?relocateeId=%d&pageIndex=0&pageSize=1000",[AppSettings sharedSettings].relocateeId];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){

            if (!_list){
                _list=[[NSMutableArray alloc] init];
            }else{
                [_list removeAllObjects];
            }
            for (id item in json[@"result"][@"list"]) {
                ExpenseItem *ex = [[ExpenseItem alloc] initWithJSON:item];
                [_list addObject:ex];
            }
            if (!_summaryList){
                _summaryList = [[NSMutableArray alloc] init];
                
            }else{
                [_summaryList removeAllObjects];
            }
            [_summaryList addObject:@{@"key":@"Total Records:",@"value":[NSString stringWithFormat:@"%@",json[@"result"][@"count"]],@"icon":@"total_list"}];
             [_summaryList addObject:@{@"key":@"Grand total:",@"value":[NSString stringWithFormat:@"%@ USD",json[@"result"][@"amount"]],@"icon":@"grand_total_list"}];
              [_summaryList addObject:@{@"key":@"NetCheck Total:",@"value":[NSString stringWithFormat:@"%@ USD",json[@"result"][@"netcheck"]],@"icon":@"netcheck_total_list"}];

            [[AppSettings sharedSettings] saveJsonWith:EXPENSE_SUMMARY_LIST data:_summaryList];
            [self.tableView reloadData];
        }
    }];
}

@end
