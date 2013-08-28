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
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
@interface EditExpenseReportControler ()<UIAlertViewDelegate>{
    id _list;
    id _tempList;
    int _childCount;
    int _menuIndex;
    BOOL _needSave;
    NSDate *_begindate;
    NSDate *_enddate;
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
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backToreport)];
    [self init_report];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dateChoosed:) name:MESSAGE_CHOOSE_DATE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDetail:) name:MESSAGE_SAVE_DETAIL object:nil];
}
-(void)backToreport{
    if (!_needSave){
        for (ERReportDetail *detail  in [_list objectAtIndex:1]) {
            if (detail.detailId==0){
                _needSave = YES;
                break;
            }
            if (detail.isRemove){
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
-(void)save
{
    id part1 = [_list objectAtIndex:0];
    self.report.name = [part1 objectAtIndex:0][@"value"];
    if ([self.report.name isEqual:@""]){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please input report name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }else{
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/existsReportName?name=%@&relocateeId=%d&reportId=%d",self.report.name,[AppSettings sharedSettings].relocateeId,self.report.reportId ];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                if ([json[@"result"] boolValue]){
                    [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Report name exist,please change it." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
                    
                    return;
                }else{
                    [self save_next];
                }
                
            }
        }];
    }
}
-(void)save_next{
    id part1 = [_list objectAtIndex:0];
    self.report.people_covered = [[part1 objectAtIndex:3][@"value"] intValue];
    self.report.description =[part1 objectAtIndex:4][@"value"];
    
    if (self.report.reportId==0){
        // add new report;
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
                [self saveDetail:report isEdit:NO];
            }
        }];
    }else{
        //edit report
        NSString *url = [NSString stringWithFormat:@"ExpenseReports/editReport?reportId=%d&userid=%d&name=%@&beginDate=%@&endDate=%@&peopleCovered=%d&description=%@",
                         self.report.reportId,
                         [AppSettings sharedSettings].userid,
                         self.report.name,
                         self.report.begin_date,
                         self.report.end_date,
                         self.report.people_covered,
                         self.report.description];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){

                [self saveDetail:self.report isEdit:YES];
            }
        }];
    }

    
}

-(void)saveReceipts:(int )detailId items:(NSArray *)items isEdit:(BOOL)isEdit{
    int i=0;
    for (ExpenseReceipt *receipt in items) {
        i++;
        if (receipt.isRemove && receipt.receiptId>0){
            NSString *url = [NSString stringWithFormat:@"ExpenseReport/removeReceipt?receiptId=%d",receipt.receiptId];
            [[AppSettings sharedSettings].http get:url block:^(id json) {
                
            }];
            continue;
        }
        if (receipt.isNoteEdit==NO && receipt.isImageEdit==NO){
            continue;
        }
        if (receipt.image==nil){
            //without image
            NSString *url = [NSString stringWithFormat:@"ExpenseReports/addReceiptNote?userid=%d&reportId=%d&detailId=%d&note=%@&receiptId=%d&imageEdit=%d",
                             [AppSettings sharedSettings].userid,
                             self.report.reportId,
                             detailId,
                             receipt.note,
                             receipt.receiptId,
                             receipt.isImageEdit?1:0];
            [[AppSettings sharedSettings].http get:url block:^(id json) {
                
            }];
        }else{
            //with image;
            NSString *url =[NSString stringWithFormat:@"ExpenseReports/addReceiptNoteAndImage"];
            
            NSData *imageData = UIImagePNGRepresentation(receipt.image);
            AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:ServerUrl]];
            NSURLRequest *request = [client multipartFormRequestWithMethod:@"POST" path:url parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
                NSString *filename = [NSString stringWithFormat:@"_%d_%d_%d.png",self.report.reportId,detailId,i];
                [formData appendPartWithFileData:imageData name:@"userfile" fileName:filename mimeType:@"image/png"];
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",self.report.reportId] dataUsingEncoding:NSUTF8StringEncoding]  name:@"reportId"];
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",detailId] dataUsingEncoding:NSUTF8StringEncoding]  name:@"detailId"];
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",receipt.receiptId] dataUsingEncoding:NSUTF8StringEncoding]  name:@"receiptId"];
                [formData appendPartWithFormData:[[NSString stringWithFormat:@"%d",[AppSettings sharedSettings].userid] dataUsingEncoding:NSUTF8StringEncoding]  name:@"userId"];
                [formData appendPartWithFormData:[receipt.note dataUsingEncoding:NSUTF8StringEncoding]  name:@"note"];
                [formData appendPartWithFormData:[receipt.isImageEdit?@"1":@"0" dataUsingEncoding:NSUTF8StringEncoding]  name:@"imageEdit"];
                
                
                
            }];
            AFHTTPRequestOperation *operation=[[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                NSError *error = nil;
                id jsonResult =[NSJSONSerialization JSONObjectWithData:operation.responseData options:NSJSONReadingMutableContainers error:&error];
                NSLog(@"%@",jsonResult);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"Access server error:%@,because %@",error,operation.request);
                
                
            }];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [queue addOperation:operation];
        }
    }
}
-(void)saveDetail:(ERReport *)report isEdit:(BOOL)isEdit{
    if (!_tempList){
        _tempList = [[NSMutableArray alloc] init];
    }else{
        [_tempList removeAllObjects];
    }
    _childCount = [[_list objectAtIndex:1] count];
    if (_childCount==0){
        [self updateExpense:_tempList report:report];
    }
    if (isEdit){
        for (ERReportDetail *detail in [_list objectAtIndex:1]) {
            if (detail.detailId==0){
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
                        ERReportDetail *temp =[[ERReportDetail alloc] initWithJSON:json[@"result"]];

                        [self saveReceipts:temp.detailId items:[NSArray arrayWithArray:detail.items] isEdit:NO];
                        [_tempList addObject:temp];
                        _childCount--;
                        if (_childCount==0){
                            [self updateExpense:_tempList report:report];
                        }
                    }
                }];
            }else{
                if (detail.isRemove){
                    NSString *url = [NSString stringWithFormat:@"ExpenseReports/removeDetail?detailId=%d",detail.detailId];
                    [[AppSettings sharedSettings].http get:url block:^(id json) {
                        if ([[AppSettings sharedSettings] isSuccess:json]){
                            _childCount--;
                            if (_childCount==0){
                                [self updateExpense:_tempList report:report];
                            }
                        }
                    }];
                }else{
                    NSString *url = [NSString stringWithFormat:@"ExpenseReports/editDetail?detailId=%d&userid=%d&purposeId=%d&serviceId=%d&date=%@&amount=%1.2f&miles=%1.2f",
                                     detail.detailId,
                                     [AppSettings sharedSettings].userid,
                                     detail.purposeId,
                                     detail.serviceId,
                                     detail.expense_date,
                                     detail.amount,
                                     detail.mileage];
                    [[AppSettings sharedSettings].http get:url block:^(id json) {
                        if ([[AppSettings sharedSettings] isSuccess:json]){
                            ERReportDetail *temp =[[ERReportDetail alloc] initWithJSON:json[@"result"]];
                            [self saveReceipts:temp.detailId items:[NSArray arrayWithArray:detail.items] isEdit:YES];
                            [_tempList addObject:temp];
                            _childCount--;
                            if (_childCount==0){
                                [self updateExpense:_tempList report:report];
                            }
                        }
                    }];
                }
            }
            
        }
    }else{
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
                    ERReportDetail *temp =[[ERReportDetail alloc] initWithJSON:json[@"result"]];
                    [self saveReceipts:temp.detailId items:[NSArray arrayWithArray:detail.items] isEdit:NO];
                    [_tempList addObject:temp];
                    _childCount--;
                    if (_childCount==0){
                        [self updateExpense:_tempList report:report];
                    }
                }
            }];
        }
    }
    
}
-(void)updateExpense:(NSArray *)list report:(ERReport *)report{
    
    [[_list objectAtIndex:1] removeAllObjects];
    [[_list objectAtIndex:1] addObjectsFromArray:list];
    [self.tableView reloadData];
    _needSave = NO;

    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_REPORT_SAVE object:report];
    [self backtoparent];
}
-(void)getDetail:(NSNotification *)notification
{
    NSLog(@"%@",notification.object);
    _needSave = YES;
    ERReportDetail *detail = notification.object;
    NSMutableArray *detailList = [_list objectAtIndex:1];
    BOOL *exists = NO;
    for (ERReportDetail *item in detailList) {
        if ([detail isEqual:item]){
            exists = YES;
        }
    }
    
    if (!exists){
        [[_list objectAtIndex:1] addObject:notification.object];
    }
    
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
    }else if (indexPath.section==1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
        }
        
        if (indexPath.row==[[_list objectAtIndex:indexPath.section] count]){
            cell.textLabel.text = @"Add New Expense";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more_btn_over"]];
        }else{
            ERReportDetail *item = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",item.purpose,item.service];
            cell.detailTextLabel.text =[NSString stringWithFormat:@"%1.2f",item.amount];
            
            /*cell.textLabel.textColor =[UIColor whiteColor];
            cell.detailTextLabel.textColor =[UIColor whiteColor];
             */
            /*
            if (item.detailId==0){
                cell.backgroundColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:0];
            }else{
                if (item.isRemove){
                    cell.backgroundColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:0];
                }else{
                    cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:0];
                }
            }
             */
        
        }
        
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            
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
        if ([item[@"type"] isEqual:@"date"]){
            DatePickerController *controller = [[DatePickerController alloc] init];
            controller.key = item[@"key"];
            controller.currentDate = item[@"value"];
            [self.navigationController pushViewController:controller animated:YES];
            [self processDate];
            if (indexPath.row==1){
                controller.beginDate =nil;
                controller.endDate = [AppDevice stringToDate:self.report.end_date];
                if (!controller.endDate){
                    controller.endDate = _begindate;
                }
            }else if (indexPath.row==2){
                controller.endDate=nil;
                controller.beginDate = [AppDevice stringToDate:self.report.begin_date];
                if (!controller.beginDate){
                    controller.beginDate = _enddate;
                }
            }
        }
    }else if (indexPath.section==1){
        //EditReportDetailController *controller = [[EditReportDetailController alloc] initWithReport:self.report];
        EditReportDetailController *controller = [[EditReportDetailController alloc] initWithNibName:@"EditReportDetailController" bundle:nil];
        controller.report = self.report;
        if (indexPath.row==[[_list objectAtIndex:1] count]){
            controller.detail = [[ERReportDetail alloc] init];
        }else{
            controller.detail = [[_list objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            
        }
        
        [self.navigationController pushViewController:controller animated:YES];
        NSDateFormatter *formmater = [[NSDateFormatter alloc] init];
        [formmater setDateFormat:@"yyyy-MM-dd"];
        [formmater setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        if (![self.report.begin_date isEqualToString:@""]){

            
            controller.beginDate =[formmater dateFromString:self.report.begin_date];
        }
        if (![self.report.end_date isEqualToString:@""]){
            controller.endDate = [formmater dateFromString:self.report.end_date];
        }

        
    }else if (indexPath.section==2){
        _menuIndex = indexPath.row;
        if (indexPath.row==0){
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Are you sure to submit this report?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [view show];
        }else if (indexPath.row==1){
            UIAlertView *view = [[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Are you sure to drop this report?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
            [view show];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(void)init_report{
    NSString *report_name;
    if([self.report.name isEqualToString:@""]){
        report_name = [[NSString stringWithFormat:@"report_%@",[NSDate date]] substringToIndex:17];
    }else{
        report_name = self.report.name;
    }
    id part1=@[[[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Report Name:",@"value":report_name,@"type":@"",@"key":@"report_name",@"keyboard":@""}],
            [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date Begin:",@"value":self.report.begin_date,@"type":@"date",@"key":@"begin_date",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Expense Date End:",@"value":self.report.end_date,@"type":@"date",@"key":@"end_date",@"keyboard":@""}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"#People Covered:",@"value":[NSString stringWithFormat:@"%d", self.report.people_covered],@"type":@"",@"key":@"people_covered",@"keyboard":@"number"}],
               [[NSMutableDictionary alloc] initWithDictionary:@{@"label":@"Description:",@"value":self.report.description,@"type":@"",@"key":@"description",@"keyboard":@""}]];
    
    id part2 = [[NSMutableArray alloc] init];
    id part3 =@[@"Submit Report",@"Drop Report"];
    if (self.report.reportId>0){
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/details?reportId=%d",self.report.reportId];
        
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                for (id item in json[@"result"]) {
                    ERReportDetail *detail = [[ERReportDetail alloc] initWithJSON:item];
                    [part2 addObject:detail];
                }
                _list = @[part1,part2,part3];
                [self.tableView reloadData];
            }
        }];
    }else{
        _list = @[part1,part2,part3];
        [self.tableView reloadData];

    }
    
    
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"%d=%d",_menuIndex,buttonIndex);
    if (buttonIndex==1){
        if (_menuIndex==-1){
            [self backtoparent];
        }else  if (_menuIndex==0){
            //submit
            [self backtoparent];
        }else if (_menuIndex==1){
            //drop
            NSString *url = [NSString stringWithFormat:@"ExpenseReports/removeReport?reportId=%d",self.report.reportId];
            [[AppSettings sharedSettings].http get:url block:^(id json) {
                if ([[AppSettings sharedSettings] isSuccess:json]){
                    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_REPORT_DROP object:self.report];
                    [self backtoparent];
                }
            }];
        }
    }
}
-(void)processDate{
    for (ERReportDetail *detail in [_list objectAtIndex:1]){
        if (detail.expense_date){
            if (!_begindate)
                _begindate =[AppDevice stringToDate:detail.expense_date];
            if (!_enddate)
                _enddate = [AppDevice stringToDate:detail.expense_date];
            
            NSDate *tempdate = [AppDevice stringToDate:detail.expense_date];
            if ([tempdate compare:_begindate]==NSOrderedAscending)
                _begindate = tempdate;
            if ([tempdate compare:_enddate]==NSOrderedDescending)
                _enddate = tempdate;
        }
    }
    
}
@end
