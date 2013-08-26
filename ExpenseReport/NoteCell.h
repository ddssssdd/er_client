//
//  NoteCell.h
//  ExpenseReport
//
//  Created by Steven Fu on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ERReport.h"
@class NoteCell;

@protocol NoteCellDelegate
-(void)gotoView:(NoteCell *)cell;
-(void)gotoEdit:(NoteCell *)cell;
@end
@interface NoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageNote;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic) ExpenseReceipt *receipt;
@property (nonatomic) id<NoteCellDelegate> delegate;

-(id)initWithNib;
-(void)loadImage:(NSString *)filename;
@end
