//
//  EditExpenseReportControler.m
//  ExpenseReport
//
//  Created by Fu Steven on 7/2/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "EditExpenseReportControler.h"
#import "EditTableRowCell.h"
#import "DatePickerController.h"
#import "EditReportDetailController.h"

@interface EditExpenseReportControler (){
    id _list;
}

@end

@implementation EditExpenseReportControler

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    [self init_report];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChoosed:) name:MESSAGE_CHOOSE_DATE object:nil];
}
-(void)save
{

}

-(void)dateChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        NSLog(@"%@",data);
        [self changeValue:data[@"key"] value:data[@"value"]];
    }
}

-(void)changeValue:(NSString *)key value:(NSString *)value{
    id part1 = [_list objectAtIndex:0];
    for (id item in part1) {
        if ([item[@"key"] isEqual:key]){
            item[@"value"] = value;
        }
    }
    NSLog(@"%@",part1);
    [self.tableView reloadData];
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
    if (section==0){
        return [[_list objectAtIndex:section] count];
    }else{
        return [[_list objectAtIndex:section] count]+1;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    

    if (indexPath.section==0){
        id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        EditTableRowCell *cell = [[EditTableRowCell alloc] initWithNib];
        cell.lable.text = item[@"label"];
        cell.text.text =item[@"value"];
        if ([item[@"type"] isEqual:@"date"]){
            cell.text.enabled = false;
            cell.text.borderStyle=UITextBorderStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row==[[_list objectAtIndex:indexPath.section] count]){
            cell.textLabel.text = @"Add New Expense";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0){
        id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        if ([item[@"type"] isEqual:@"date"]){
            DatePickerController *controller = [[DatePickerController alloc] init];
            controller.key = item[@"key"];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else if (indexPath.section==1){
        if (indexPath.row==[[_list objectAtIndex:1] count]){
            EditReportDetailController *controller = [[EditReportDetailController alloc] initWithReport:self.report];
            controller.detail = [[ERReportDetail alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
   
    
}


-(void)init_report{
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Report Name:",@"value":self.report.name,@"type":@"",@"key":@"report_name"}],
            [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date Begin:",@"value":self.report.begin_date,@"type":@"date",@"key":@"begin_date"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date End:",@"value":self.report.end_date,@"type":@"date",@"key":@"end_date"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"#People Covered:",@"value":[NSString stringWithFormat:@"%d", self.report.people_covered],@"type":@"",@"key":@"people_covered"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Description:",@"value":self.report.description,@"type":@"",@"key":@"description"}]];
    
    id part2 = [[NSMutableArray alloc] init];
    
    _list = @[part1,part2];
    [self.tableView reloadData];
    
    
}

@end
