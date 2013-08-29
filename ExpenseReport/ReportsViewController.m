//
//  ReportsViewController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ReportsViewController.h"
#import "ReportCell.h"
#import "ERReport.h"
#import "ReportDetailController.h"
#import "EditExpenseReportControler.h"
#import "HeaderView.h"
#import "FooterView.h"
@interface ReportsViewController (){
    NSArray *_reportstatus;
    id _list;
}

@end

@implementation ReportsViewController

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
    self.title = @"Reports";
    self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Reports" image:[UIImage imageNamed:@"0051"] tag:0];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNew)];
    /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *butImage = [[UIImage imageNamed:@"add_btn_over"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [button setBackgroundImage:butImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNew) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 48, 30);
    UIBarButtonItem *addButon = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = addButon;
     */
    
    self.navigationItem.rightBarButtonItem =[self createCustomNavButton:@"add_btn_over" action:@selector(addNew)];
    self.refreshControl =[[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(initData) forControlEvents:UIControlEventValueChanged];
    [self initData];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:MESSAGE_REPORT_SAVE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:MESSAGE_REPORT_DROP object:nil];
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

    return [[_list objectAtIndex:section][@"list"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ReportCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[ReportCell alloc] initWithNib];
    }
    
    id item = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    cell.lblName.text = item[@"Name"];
   // cell.lblDescription.text =[[AppSettings sharedSettings] getString: item[@"Description"]];
    cell.lblReportDate.text = [[AppSettings sharedSettings] getDateString:item[@"ReportDate"]];
    cell.lblPeriodBegin.text=[[AppSettings sharedSettings] getDateString:item[@"PeriodBeginDate"]];
    cell.lblPeriodEnd.text=[[AppSettings sharedSettings] getDateString:item[@"PeriodEndDate"]];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_list objectAtIndex:section][@"status"][@"Description"];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ReportCell cellWidth];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HeaderView *view = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [view initWithTitle:[_list objectAtIndex:section][@"status"][@"Description"] ];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FooterView *view = [[FooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 22)];

    return view;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id item = [[_list objectAtIndex:indexPath.section][@"list"] objectAtIndex:indexPath.row];
    ERReport *report = [[ERReport alloc] initWithJSON:item];
    
    if (report.status_id==1){
        EditExpenseReportControler *controller =[[EditExpenseReportControler alloc] initWithNibName:@"EditExpenseReportControler" bundle:nil];
        controller.report = report;
        [self.navigationController pushViewController:controller animated:YES];
    }else{
        ReportDetailController *vc = [[ReportDetailController alloc] initWithNibName:@"ReportDetailController" bundle:nil];
        vc.report = report;
        [self.navigationController pushViewController:vc animated:YES];
    }

    
}

-(void)initData{
    [[AppSettings sharedSettings].dict get_reportstatus:^(NSArray *list) {
        _reportstatus = list;
        NSString *url =[NSString stringWithFormat:@"ExpenseReports/reports?relocateeId=%d",[AppSettings sharedSettings].relocateeId];
        [[AppSettings sharedSettings].http get:url block:^(id json) {
            if ([[AppSettings sharedSettings] isSuccess:json]){
                [self process_data:json[@"result"]];
            }
        }];
    }];
    
    
}
-(void)process_data:(id)list{
    if (!_list){
        _list = [[NSMutableArray alloc] init];
    }else{
        [_list removeAllObjects];
    }
    for (id item  in _reportstatus) {
        NSString *status_id = item[@"ref_ERReportStatusID"];
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF.ReportStatusID = %@",status_id];
        [_list addObject:@{@"status":item,@"list":[list filteredArrayUsingPredicate:filter]}];
    
    }
    [[AppSettings sharedSettings] saveJsonWith:EXPENSEREPORT_LIST data:_list];
    [self.refreshControl endRefreshing];

    [self.tableView reloadData];
}
-(void)addNew{
    EditExpenseReportControler *controller =[[EditExpenseReportControler alloc] initWithNibName:@"EditExpenseReportControler" bundle:nil];
    controller.report = [[ERReport alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
