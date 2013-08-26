//
//  NoteCell.m
//  ExpenseReport
//
//  Created by Steven Fu on 8/26/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NoteCell.h"
#import "UIImageView+AFNetworking.h"

@implementation NoteCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buttonViewPressed:(id)sender {
    if (self.delegate){
        [self.delegate gotoView:self];
    }
}
- (IBAction)buttonEditPressed:(id)sender {
    if (self.delegate){
        [self.delegate gotoEdit:self];
    }
}

-(id)initWithNib{
    return [[[NSBundle mainBundle] loadNibNamed:[AppDevice getNibName:@"NoteCell"] owner:nil options:nil] objectAtIndex:0];
}
-(void)loadImage:(NSString *)filename{
    [self.imageNote setImageWithURL:[NSURL URLWithString:filename]];
}
@end
