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
    id _tempList;
    int _childCount;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetail:) name:MESSAGE_SAVE_DETAIL object:nil];
}
-(void)save
{
    id part1 = [_list objectAtIndex:0];
    self.report.name = [part1 objectAtIndex:0][@"value"];
    self.report.people_covered = [[part1 objectAtIndex:3][@"value"] intValue];
    self.report.description =[part1 objectAtIndex:4][@"value"];
    if ([self.report.name isEqual:@""]){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please input report name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    NSString *url = [NSString stringWithFormat:@"ExpenseReports/addReport?userid=%d&relocateeId=%d&name=%@&beginDate=%@&endDate=%@&peopleCovered=%d&description=%@",
                     [AppSettings sharedSettings].userid,
                     [AppSettings sharedSettings].relocateeId,
                     self.report.name,
                     self.report.begin_date,
                     self.report.end_date,
                     self.report.people_covered,
                     self.report.description];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            NSLog(@"%@",json);
            ERReport *report = [[ERReport alloc] initWithJSON:json[@"result"]];
            [self saveDetail:report];
        }
    }];
    
}
-(void)saveDetail:(ERReport *)report{
    if (!_tempList){
        _tempList = [[NSMutableArray alloc] init];
    }else{
        [_tempList removeAllObjects];
    }
    _childCount = [[_list objectAtIndex:1] count];
    for (ERReportDetail *detail in [_list objectAtIndex:1]) {
        NSString *url = [NSString stringWithFormat:@"ExpenseReports/addDetail?userid=%d&reportId=%d&purposeId=%d&serviceId=%d&date=%@&amount=%1.2f&miles=%1.2f",
                         [AppSettings sharedSettings].userid,
                         report.reportId,
                         detail.purposeId,
                         detail.serviceId,
                         detail.expense_date,
                         detail.amount,
                         detail.mileage];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [_tempList addObject:[[ERReportDetail alloc] initWithJSON:json[@"result"]]];
                _childCount--;
                if (_childCount==0){
                    [[_list objectAtIndex:1] removeAllObjects];
                    [[_list objectAtIndex:1] addObjectsFromArray:_tempList];
                    [self.tableView reloadData];
                }
            }
        }];
    }
}
-(void)getDetail:(NSNotification *)notification
{
    NSLog(@"%@",notification.object);
    [[_list objectAtIndex:1] addObject:notification.object];
    [self.tableView reloadData];
}
-(void)dateChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){

        [self changeValue:data[@"key"] value:data[@"value"]];
        if ([data[@"key"] isEqual:@"begin_date"]){
            self.report.begin_date = data[@"value"];
        }
        if ([data[@"key"] isEqual:@"end_date"]){
            self.report.end_date = data[@"value"];
        }
    }
}

-(void)changeValue:(NSString *)key value:(NSString *)value{
    id part1 = [_list objectAtIndex:0];
    for (id item in part1) {
        if ([item[@"key"] isEqual:key]){
            item[@"value"] = value;
        }
    }

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
        }else{
            if ([item[@"keyboard"] isEqual:@"number"]){
                cell.text.keyboardType = UIKeyboardTypeDecimalPad;
            }else{
                cell.text.keyboardType = UIKeyboardTypeDefault;
            }
            cell.text.tag  = indexPath.row;
            [cell.text addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
            cell.text.delegate = self;
        }
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
        }
        
        if (indexPath.row==[[_list objectAtIndex:indexPath.section] count]){
            cell.textLabel.text = @"Add New Expense";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else{
            ERReportDetail *item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",item.purpose,item.service];
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%1.2f",item.amount];
        }
        
        return cell;
    }
    
}
-(void)textChanged:(UITextField *)sender{
    
    id item = [[_list objectAtIndex:0] objectAtIndex:sender.tag];
    item[@"value"] = sender.text;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Report Name:",@"value":self.report.name,@"type":@"",@"key":@"report_name",@"keyboard":@""}],
            [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date Begin:",@"value":self.report.begin_date,@"type":@"date",@"key":@"begin_date",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date End:",@"value":self.report.end_date,@"type":@"date",@"key":@"end_date",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"#People Covered:",@"value":[NSString stringWithFormat:@"%d", self.report.people_covered],@"type":@"",@"key":@"people_covered",@"keyboard":@"number"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Description:",@"value":self.report.description,@"type":@"",@"key":@"description",@"keyboard":@""}]];
    
    id part2 = [[NSMutableArray alloc] init];
    
    if (self.report.reportId>0){
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/details?reportId=%d",self.report.reportId];
        
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                for (id item in json[@"result"]) {
                    ERReportDetail *detail = [[ERReportDetail alloc] initWithJSON:item];
                    [part2 addObject:detail];
                }
                _list = @[part1,part2];
                [self.tableView reloadData];
            }
        }];
    }else{
        _list = @[part1,part2];
        [self.tableView reloadData];

    }
    
    
}

@end
