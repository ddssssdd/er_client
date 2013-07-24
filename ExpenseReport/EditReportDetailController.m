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
@interface EditReportDetailController ()<UIAlertViewDelegate>{
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
    id part1 = [_list objectAtIndex:0];
    self.detail.amount = [[part1 objectAtIndex:3][@"value"] floatValue];
    self.detail.mileage =[[part1 objectAtIndex:4][@"value"] floatValue];
    if (self.detail.serviceId==0){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please choose one service." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if (self.detail.purposeId==0){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please choose one purpose." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    if ([self.detail.expense_date isEqual:@""]){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please input expense date." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SAVE_DETAIL object:self.detail];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dateChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        [self changeValue:data[@"key"] value:data[@"value"]];
        self.detail.expense_date = data[@"value"];
    }
}
-(void)itemsChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        [self changeValue:data[@"key"] value:data[@"value"][@"Description"]];
        if ([data[@"key"] isEqual:@"purpose"]){
            self.detail.purposeId = [data[@"value"][@"ERExpensePurposeID"] intValue];
            self.detail.purpose = data[@"value"][@"Description"];
        }
        if ([data[@"key"] isEqual:@"service"]){
            self.detail.serviceId =[data[@"value"][@"ERExpenseserviceID"] intValue];
            self.detail.service =data[@"value"][@"Description"];
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
    if (section==1){
        return [[_list objectAtIndex:section] count]+1;
    }else{
        return [[_list objectAtIndex:section] count];
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
    }else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row==[[_list objectAtIndex:indexPath.section] count]){
            cell.textLabel.text = @"Add Note";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        id item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.textLabel.text = item;
        
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
        if ([item[@"type"] isEqual:@"choose"]){
            if ([item[@"key"] isEqual:@"expense_date"]){
                DatePickerController *controller = [[DatePickerController alloc] init];
                controller.key = item[@"key"];
                [self.navigationController pushViewController:controller animated:YES];
            }else if ([item[@"key"] isEqual:@"purpose"]){
                [[AppSettings sharedSettings].dict get_purposes:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"purpose";
                    controller.selected = self.detail.purposeId;
                    controller.fieldName = @"ERExpensePurposeID";
                    [self.navigationController pushViewController:controller animated:YES];
                }];
            }else if ([item[@"key"] isEqual:@"service"]){
                [[AppSettings sharedSettings].dict get_services:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"service";
                    controller.selected = self.detail.serviceId;
                    controller.fieldName = @"ERExpenseserviceID";                    
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
    }else if (indexPath.section==2){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:@"Are you sure to %@ drop this expense?",self.detail.isRemove?@"UNDO":@""] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:self.detail.isRemove?@"Undo":@"Drop", nil] show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        self.detail.isRemove = !self.detail.isRemove;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
-(void)init_report_detail{
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date:",@"value":self.detail.expense_date,@"type":@"choose",@"key":@"expense_date",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Purpose:",@"value":self.detail.purpose,@"type":@"choose",@"key":@"purpose",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Service:",@"value":self.detail.service, @"type":@"choose",@"key":@"service",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Amount:",@"value":[NSString stringWithFormat:@"%1.2f", self.detail.amount],@"type":@"",@"key":@"amount",@"keyboard":@"number"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Miles:",@"value":[NSString stringWithFormat:@"%1.2f", self.detail.mileage],@"type":@"",@"key":@"mileage",@"keyboard":@"number"}]
               ];
    
    id part2 = [[NSMutableArray alloc] init];
    
    if (self.detail.detailId>0){
        _list = @[part1,part2,@[self.detail.isRemove?@"Undo Drop":@"Drop expense"]];
    }else{
        _list = @[part1,part2];
    }
    
    [self.tableView reloadData];
}

@end
