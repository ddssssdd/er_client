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
}
-(void)save
{

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
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
   
    
}


-(void)init_report{
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Report Name:",@"value":self.report.name,@"type":@""}],
            [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date Begin:",@"value":self.report.begin_date,@"type":@"date"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date End:",@"value":self.report.end_date,@"type":@"date"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"#People Covered:",@"value":[NSString stringWithFormat:@"%d", self.report.people_covered],@"type":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Description:",@"value":self.report.description,@"type":@""}]];
    
    id part2 = [[NSMutableArray alloc] init];
    
    _list = @[part1,part2];
    [self.tableView reloadData];
    
    
}

@end
