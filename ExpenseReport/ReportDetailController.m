//
//  ReportDetailController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ReportDetailController.h"
#import "ERReport.h"
#import "ReportDetailCell.h"

@interface ReportDetailController (){
    id _list;
   
}

@end

@implementation ReportDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=[NSString stringWithFormat:@"%@(%@)",self.report.name,self.report.report_status];
    self.txtName.text = self.report.name;
    self.txtDescription.text = self.report.description;
    self.txtBegin.text = self.report.begin_date;
    self.txtEnd.text = self.report.end_date;
    self.txtPeopleCovered.text = [NSString stringWithFormat:@"%d",self.report.people_covered];
    
    
    [self load_detail];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)load_detail{
    NSString *url =[NSString stringWithFormat:@"ExpenseReports/details?reportId=%d",self.report.reportId];

    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            if (!_list){
                _list =[[NSMutableArray alloc] init];
            }else{
                [_list removeAllObjects];
            }
            for (id item in json[@"result"]) {
                ERReportDetail *detail = [[ERReportDetail alloc] initWithJSON:item];
                [_list addObject:detail];
            }
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier = @"ReportDetailCell";
    ReportDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil){
        cell =[[ReportDetailCell alloc] initWithNib];
    }
    ERReportDetail *item = [_list objectAtIndex:indexPath.row];
    cell.lblTitle.text = item.detailTitle;
    cell.lblDate.text = item.expense_date;
    cell.lblStatus.text =@"status";
    cell.lblAmount.text=[NSString stringWithFormat:@"%1.2fUSD",item.amount];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
@end
