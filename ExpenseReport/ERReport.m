//
//  ERReport.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ERReport.h"

@implementation ERReport

-(id)init{
    self = [super init];
    if (self){
        self.name = @"";
        self.description =@"";
        self.report_date= @"";
        self.begin_date=@"";
        self.end_date=@"";
        self.reportId = 0;
        self.people_covered = 0;
        self.status_id =0;
    }
    return self;
}
-(id)initWithJSON:(id)json{
    self = [self init];
    if (self){
        self.name = json[@"Name"];
        self.description =[[AppSettings sharedSettings] getString: json[@"Description"]];
        self.report_date= [[AppSettings sharedSettings] getDateString:json[@"ReportDate"]];
        self.begin_date=[[AppSettings sharedSettings] getDateString:json[@"PeriodBeginDate"]];
        self.end_date=[[AppSettings sharedSettings] getDateString:json[@"PeriodEndDate"]];
        self.reportId = [json[@"ExpenseReportID"] intValue];
        self.people_covered = [json[@"PeopleCovered"] intValue];
        self.status_id =[json[@"ReportStatusID"] intValue];
        [[AppSettings sharedSettings].dict get_reportstatus:^(NSArray *reports) {
        
            int index = [reports indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj[@"ref_ERReportStatusID"] intValue]==self.status_id;
            }];
            if (index>-1){
                self.report_status =[reports objectAtIndex:index][@"Description"];
            }
            
        }];
        
        
    }
    return  self;
}

@end
//******************************************** ER Report Detail******************************************
@implementation ERReportDetail

-(id)init{
    self = [super init];
    if (self){
        self.detailId =0;
        self.reportId =0;
        self.purposeId =0;
        self.purpose=@"";
        self.serviceId=0;
        self.service =@"";
        self.amount = 0;
        self.total_amount = 0;
        self.expense_date = @"";
        self.return_reason =@"";
        self.paidbyco=0;
        self.mileage =0.0f;
        self.expenseId =0;
    }
    return self;
}

-(id)initWithJSON:(id)json{
    self =[super init];
    if (self){
        self.detailId = [json[@"ExpenseReportDetailID"] intValue];
        self.reportId = [json[@"ExpenseReportID"] intValue];
        self.purposeId =[json[@"ExpensePurposeID"] intValue];
        self.serviceId=[json[@"ExpenseServiceID"] intValue];
        self.expense_date =[[AppSettings sharedSettings] getDateString:json[@"ExpenseDate"]];
        self.amount =[json[@"Amount"] floatValue];
        self.total_amount =[json[@"TotalAmount"] floatValue];
        self.return_reason = [[AppSettings sharedSettings] getString:json[@"ReturnReason"]];
        self.paidbyco =[json[@"PaidByCo"] intValue];
        self.expenseId = [json[@"ExpenseID"] intValue];
        self.mileage = [json[@"Mileage"] floatValue];
        [[AppSettings sharedSettings].dict get_purposes:^(NSArray *list) {

            int index = [list indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj[@"ERExpensePurposeID"] intValue]==self.purposeId;
            }];
            if (index!=NSNotFound){
                self.purpose =[list objectAtIndex:index][@"Description"];
            }
        }];
        [[AppSettings sharedSettings].dict get_services:^(NSArray *list) {
            
            int index = [list indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                return [obj[@"ERExpenseserviceID"] intValue]==self.serviceId;
            }];
            if (index!=NSNotFound){
                self.service =[list objectAtIndex:index][@"Description"];
            }
        }];
        
        
    }
    return self;
}

-(NSString *)detailTitle{
    return [NSString stringWithFormat:@"%@-%@",self.purpose,self.service];
}

@end
@implementation ExpenseItem

-(id)initWithJSON:(id)json{
    self =[super init];
    if (self){
        self.expenseId = [json[@"ExpenseID"] intValue];
        self.relocateeId = [json[@"EntityID"] intValue];
        self.amount = [[AppSettings sharedSettings] getFloat:json[@"Amount"]];
        self.netcheck = [[AppSettings sharedSettings] getFloat:json[@"NetCheck"] ]; 
        self.description = [[AppSettings sharedSettings] getString:json[@"ExpenseCodeDescription"]];
        self.full_name =[[AppSettings sharedSettings] getString:json[@"ExpenseGroupFullName"]];
        self.report_date =[[AppSettings sharedSettings] getDateString:json[@"ReportDate"]];
        self.paidto =[[AppSettings sharedSettings] getString:json[@"PaidTo"]];
    }
    return self;
}

@end