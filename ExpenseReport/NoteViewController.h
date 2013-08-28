//
//  NoteViewController.h
//  ExpenseReport
//
//  Created by Steven Fu on 7/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
#import "BaseViewController.h"

@interface NoteViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textNote;

@property (nonatomic) ExpenseReceipt *receipt;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end
