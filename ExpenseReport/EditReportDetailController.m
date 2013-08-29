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
#import "NoteViewController.h"

#import "NoteCell.h"
@interface EditReportDetailController ()<UIAlertViewDelegate,NoteCellDelegate>{
    id _list;
    BOOL _needSave;
    int _menuIndex;
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
    _menuIndex = -2;

    //self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    //self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backTo)];
    self.navigationItem.rightBarButtonItem =[self createCustomNavButton:@"done_btn_out" action:@selector(save)];
    self.navigationItem.leftBarButtonItem =[self createCustomNavButton:@"cancel_btn_out" action:@selector(backTo)];
    [self init_report_detail];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemsChoosed:) name:MESSAGE_CHOOSE_ITEM object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChoosed:) name:MESSAGE_CHOOSE_DATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiptSave:) name:MESSAGE_SAVE_RECEIPT object:nil];
    self.title = self.report.name;

}


-(void)backTo{
    if (!_needSave){
        for (ExpenseReceipt *receipt in self.detail.items) {
            if (receipt.receiptId==0 && !receipt.isConfirmed){
                _needSave = YES;
                break;
            }
            if (receipt.isRemove){
                _needSave = YES;
                break;
            }
        }
        
    }
    if (_needSave){
        _menuIndex = -1;
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Do you want to discard changes and quit?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Quit",nil] show];
        return;
    }else{
        [self backtoparent];
    }
}
-(void)backtoparent{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
     [self.navigationController popViewControllerAnimated:YES];
}
-(void)save{
    id part1 = [_list objectAtIndex:0];
    self.detail.amount = [[part1 objectAtIndex:3][@"value"] floatValue];
    self.detail.mileage =[[part1 objectAtIndex:4][@"value"] floatValue];
    NSString *date = [part1 objectAtIndex:0][@"dict_id"];
    if (![date isEqualToString:@""]){
        self.detail.expense_date = date;
    }
    NSString *purposeId = [NSString stringWithFormat:@"%@",[part1 objectAtIndex:1][@"dict_id"]];
    if (![purposeId isEqualToString:@""]){
        self.detail.purpose = [part1 objectAtIndex:1][@"value"];
        self.detail.purposeId = [purposeId intValue];
    }
    NSString *serviceId = [NSString stringWithFormat:@"%@",[part1 objectAtIndex:2][@"dict_id"]];
    if (![serviceId isEqualToString:@""]){
        self.detail.service = [part1 objectAtIndex:2][@"value"];
        self.detail.serviceId =[serviceId intValue];
    }
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
    for (ExpenseReceipt *r in self.detail.items) {
        r.isConfirmed = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SAVE_DETAIL object:self.detail];
    [self backtoparent];
}
-(void)receiptSave:(NSNotification *)notification{
    ExpenseReceipt *receipt = notification.object;
    BOOL exists = NO;
    for (ExpenseReceipt *r in [_list objectAtIndex:1]) {
        if ([r isEqual:receipt]){
            exists = YES;
        }
    }
    if (!exists){
        
        [[_list objectAtIndex:1] addObject:receipt];
    }
    [self.tableView reloadData];
    _needSave = YES;
}

-(void)dateChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        [self changeValue:data[@"key"] value:data[@"value"] value2:data[@"value"]];
        //self.detail.expense_date = data[@"value"];

    }
    
}
-(void)itemsChoosed:(NSNotification *)notification{
    id data = notification.userInfo;
    if (data){
        
        if ([data[@"key"] isEqual:@"purpose"]){
            [self changeValue:data[@"key"] value:data[@"value"][@"Description"] value2:data[@"value"][@"ERExpensePurposeID"]];
            
            //self.detail.purposeId = [data[@"value"][@"ERExpensePurposeID"] intValue];
            //self.detail.purpose = data[@"value"][@"Description"];
        }
        if ([data[@"key"] isEqual:@"service"]){
            [self changeValue:data[@"key"] value:data[@"value"][@"Description"] value2:data[@"value"][@"ERExpenseserviceID"]];

            //self.detail.serviceId =[data[@"value"][@"ERExpenseserviceID"] intValue];
            //self.detail.service =data[@"value"][@"Description"];
        }
       
    }
}

-(void)changeValue:(NSString *)key value:(NSString *)value value2:(NSString *)value2{
    id part1 = [_list objectAtIndex:0];
    for (id item in part1) {
        if ([item[@"key"] isEqual:key]){
            item[@"value"] = value;
            item[@"dict_id"] = value2;
        }
    }
    _needSave = YES;
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1){
        if (indexPath.row==[[_list objectAtIndex:1] count]){
            return 44.0f;
        }else{
            ExpenseReceipt *receipt =[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (receipt.isImageEdit){
                return 100.0f;
            }
            if (![receipt.filename isEqualToString:@""]){
                // exist url;
                return 100.0f;
            }else{
                if (receipt.image!=nil){
                    //just add or edit
                    return 100.0f;
                }else{
                    //no image;
                    return 44.0f;
                }
            }

        }
    }else{
        return  44.0f;
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
                
        if (indexPath.row==[[_list objectAtIndex:indexPath.section] count]){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }

            cell.textLabel.text = @"Add Note";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_btn_over"]];
            return cell;
        }else{

            ExpenseReceipt *receipt =[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            if (![receipt.filename isEqualToString:@""] || receipt.image!=nil){
                NoteCell *cell = [[NoteCell alloc] initWithNib];
                cell.noteLabel.text = receipt.note;
                cell.dateLabel.text = receipt.update_date;
                cell.receipt = receipt;

                cell.delegate = self;
                if (receipt.isImageEdit){
                    cell.imageNote.image = receipt.image;
                }else if (![receipt.filename isEqualToString:@""]){
                
                    [cell loadImage:receipt.filename];
                    
                }else{
                    if (receipt.image!=nil){
                        cell.imageNote.image = receipt.image;
                    }
                }
                if (receipt.receiptId==0){
                    cell.imageView.image = [AppHelper addImage];
                    cell.noteLabel.textColor =[UIColor greenColor];
                    cell.dateLabel.textColor =[UIColor greenColor];
                }else{
                    
                    if (receipt.isRemove){
                        cell.imageView.image = [AppHelper removeImage];
                        cell.noteLabel.textColor =[UIColor redColor];
                        cell.dateLabel.textColor =[UIColor redColor];
                    }else{
                        cell.imageView.image = [AppHelper editImage];
                    }
                }
                return cell;
            }else{
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
                }
                
                cell.textLabel.text = receipt.note;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                if (receipt.receiptId==0){
                    cell.imageView.image = [AppHelper addImage];
                    cell.textLabel.textColor =[UIColor greenColor];
                }else{
                    
                    if (receipt.isRemove){
                        cell.imageView.image = [AppHelper removeImage];
                        cell.textLabel.textColor =[UIColor redColor];
                    }else{
                        cell.imageView.image = [AppHelper editImage];
                    }
                }
                return cell;
            }
            
        }
        
        
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

-(void)gotoView:(NoteCell *)cell{
    // note yet;
}
-(void)gotoEdit:(NoteCell *)cell{
    NoteViewController *controller = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
    controller.receipt =cell.receipt;
    [self.navigationController pushViewController:controller animated:YES];
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
                controller.currentDate = item[@"value"];
                [self.navigationController pushViewController:controller animated:YES];
                controller.beginDate = self.beginDate;
                controller.endDate = self.endDate;
                controller.title = self.report.name;
            }else if ([item[@"key"] isEqual:@"purpose"]){
                [[AppSettings sharedSettings].dict get_purposes:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"purpose";
                    controller.selected = self.detail.purposeId;
                    controller.fieldName = @"ERExpensePurposeID";
                    [self.navigationController pushViewController:controller animated:YES];
                    controller.title = self.report.name;
                }];
            }else if ([item[@"key"] isEqual:@"service"]){
                [[AppSettings sharedSettings].dict get_services:^(NSArray *list) {
                    ItemsPickerController *controller = [[ItemsPickerController alloc] initWithList:list];
                    controller.key = @"service";
                    controller.selected = self.detail.serviceId;
                    controller.fieldName = @"ERExpenseserviceID";                    
                    [self.navigationController pushViewController:controller animated:YES];
                    controller.title = self.report.name;
                }];
            }

        }
    }else if (indexPath.section==1){
        if (indexPath.row==[[_list objectAtIndex:1] count]){
            
            NoteViewController *controller = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
            controller.receipt =[[ExpenseReceipt alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
            controller.title = self.report.name;
        }else{
            NoteViewController *controller = [[NoteViewController alloc] initWithNibName:@"NoteViewController" bundle:nil];
            controller.receipt =[[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:controller animated:YES];
            controller.title = self.report.name;
        }
    }else if (indexPath.section==2){
        _menuIndex = 0;
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:[NSString stringWithFormat:@"Are you sure to %@ drop this expense?",self.detail.isRemove?@"UNDO":@""] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:self.detail.isRemove?@"Undo":@"Drop", nil] show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1){
        if (_menuIndex==0){
            self.detail.isRemove = !self.detail.isRemove;
            [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_EXPENSE_DROP object:self.detail];
            [self backtoparent];
        }else{
            //cancel edit
            int count = [self.detail.items count];
            for(int i=count-1;i>-1;i--){
                ExpenseReceipt *receipt = [self.detail.items objectAtIndex:i];
                if (!receipt.isConfirmed){
                    [self.detail.items removeObjectAtIndex:i];
                }
            }
            [self backtoparent];
        }
        
        
    }
}
-(void)init_report_detail{
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date:",@"value":self.detail.expense_date,@"type":@"choose",@"key":@"expense_date",@"keyboard":@"",@"dict_id":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Purpose:",@"value":self.detail.purpose,@"type":@"choose",@"key":@"purpose",@"keyboard":@"",@"dict_id":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Service:",@"value":self.detail.service, @"type":@"choose",@"key":@"service",@"keyboard":@"",@"dict_id":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Amount:",@"value":[NSString stringWithFormat:@"%1.2f", self.detail.amount],@"type":@"",@"key":@"amount",@"keyboard":@"number",@"dict_id":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Miles:",@"value":[NSString stringWithFormat:@"%1.2f", self.detail.mileage],@"type":@"",@"key":@"mileage",@"keyboard":@"number",@"dict_id":@""}]
               ];
    

    
    if (self.detail.detailId>0 && !self.detail.hasLoadItems){
        NSString *url = [NSString stringWithFormat:@"ExpenseReports/receipts?reportId=%d&detailId=%d",self.report.reportId,self.detail.detailId];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                
                for (id item in json[@"result"]) {
                    ExpenseReceipt *receipt = [[ExpenseReceipt alloc] initWithJSON:item];
                    [self.detail.items addObject:receipt];
                }
                self.detail.hasLoadItems = YES;
            }
            _list = @[part1,self.detail.items,@[self.detail.isRemove?@"Undo Drop":@"Drop expense"]];
            [self.tableView reloadData];
        }];
        
    }else{
        _list = @[part1,self.detail.items];
        [self.tableView reloadData];
    }
    
    
}

@end
