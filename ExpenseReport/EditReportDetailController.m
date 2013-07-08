//
//  EditReportDetailController.m
//  ExpenseReport
//
//  Created by Steven Fu on 7/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "EditReportDetailController.h"
#import "EditTableRowCell.h"
#import "DatePickerController.h"
#import "ItemsPickerController.h"
@interface EditReportDetailController (){
    id _list;
}

@end

@implementation EditReportDetailController

-(id)initWithReport:(ERReport *)report{
    self =[super initWithStyle:UITableViewStyleGrouped];
    if (self){
        self.report = report;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    [self init_report_detail];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsChoosed:) name:MESSAGE_CHOOSE_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChoosed:) name:MESSAGE_CHOOSE_DATE object:nil];
}
-(void)save{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dateChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        NSLog(@"%@",data);
        [self changeValue:data[@"key"] value:data[@"value"]];
    }
}
-(void)itemsChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        NSLog(@"%@",data);
        
        [self changeValue:data[@"key"] value:data[@"value"][@"Description"]];
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
        if ([item[@"type"] isEqual:@"choose"]){
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
            cell.textLabel.text = @"Add Note";
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
        if ([item[@"type"] isEqual:@"choose"]){
            if ([item[@"key"] isEqual:@"expense_date"]){
                DatePickerController *controller = [[DatePickerController alloc] init];
                controller.key = item[@"key"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([item[@"key"] isEqual:@"purpose"]){
                [[AppSettings sharedSettings].dict get_purposes:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"purpose";
                    [self.navigationController pushViewController:controller animated:YES];
                }];
            }else if ([item[@"key"] isEqual:@"service"]){
                [[AppSettings sharedSettings].dict get_services:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"service";
                    [self.navigationController pushViewController:controller animated:YES];
                }];
            }

        }
    }else if (indexPath.section==1){
        if (indexPath.row==[[_list objectAtIndex:1] count]){
            EditReportDetailController *controller = [[EditReportDetailController alloc] initWithReport:self.report];
            controller.detail = [[ERReportDetail alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
    }
}
-(void)init_report_detail{
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date:",@"value":self.detail.expense_date,@"type":@"choose",@"key":@"expense_date"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Purpose:",@"value":self.detail.purpose,@"type":@"choose",@"key":@"purpose"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Service:",@"value":self.detail.service, @"type":@"choose",@"key":@"service"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Amount:",@"value":[NSString stringWithFormat:@"%1.2f", self.detail.amount],@"type":@"",@"key":@"amount"}]
               ];
    
    id part2 = [[NSMutableArray alloc] init];
    
    _list = @[part1,part2];
    [self.tableView reloadData];
}

@end
