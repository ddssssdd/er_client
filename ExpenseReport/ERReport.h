//
//  ERReport.h
//  ExpenseReport
//
//  Created by Fu Steven on 6/27/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ERReport : NSObject


@property (nonatomic) NSString *name;
@property (nonatomic) NSString *description;
@property (nonatomic) int reportId;
@property (nonatomic) NSString *report_date;
@property (nonatomic) NSString *begin_date;
@property (nonatomic) NSString *end_date;
@property (nonatomic) int people_covered;
@property (nonatomic) int status_id;
@property (nonatomic) NSString *report_status;

-(id)initWithJSON:(id)json;

@end
@interface ERReportDetail : NSObject
@property (nonatomic) int detailId;
@property (nonatomic) int reportId;
@property (nonatomic) int purposeId;
@property (nonatomic) int serviceId;
@property (nonatomic) NSString *expense_date;
@property (nonatomic) float amount;
@property (nonatomic) NSString *return_reason;
@property (nonatomic) int paidbyco;
@property (nonatomic) int expenseId;
@property (nonatomic) float mileage;
@property (nonatomic) float total_amount;

@property (nonatomic) NSString *purpose;
@property (nonatomic) NSString *service;

@property (nonatomic) NSString *detailTitle;
@property (nonatomic) BOOL isRemove;
@property (nonatomic) BOOL hasLoadItems;
@property (nonatomic) NSMutableArray *items;

-(id)initWithJSON:(id)json;

@end

@interface ExpenseItem : NSObject
@property (nonatomic) int expenseId;
@property (nonatomic) int relocateeId;
@property (nonatomic) float amount;
@property (nonatomic) NSString *description;
@property (nonatomic) NSString *paidto;
@property (nonatomic) NSString *report_date;
@property (nonatomic) NSString *full_name;
@property (nonatomic) float netcheck;

-(id)initWithJSON:(id)json;

@end
@interface ExpenseReceipt : NSObject
@property (nonatomic) int receiptId;
@property (nonatomic) int detailId;
@property (nonatomic) int reportId;
@property (nonatomic) NSString *note;
@property (nonatomic) NSString *filename;
@property (nonatomic) UIImage *image;
@property (nonatomic) NSString *update_date;
@property (nonatomic) BOOL isRemove;
@property (nonatomic) BOOL isImageEdit;
@property (nonatomic) BOOL isNoteEdit;
@property (nonatomic) BOOL isConfirmed;

-(id)initWithJSON:(id)json;
@end
