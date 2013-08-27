//
//  NoteViewController.m
//  ExpenseReport
//
//  Created by Steven Fu on 7/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "NoteViewController.h"
#import "UIImageView+AFNetworking.h"

@interface NoteViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    UIPopoverController *_popoverController;
}

@end

@implementation NoteViewController

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
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(save)];
    //[self.textNote becomeFirstResponder];
    self.textNote.text=self.receipt.note;
    if (![self.receipt.filename isEqualToString:@""]){
        [self.image setImageWithURL:[NSURL URLWithString:self.receipt.filename]];
    }else{
        if (self.receipt.image!=nil){
            self.image.image = self.receipt.image;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePhonePress:(id)sender {
    [self.textNote resignFirstResponder];
    UIActionSheet *menu = [[UIActionSheet alloc]
                           initWithTitle: APP_TITLE
                           delegate:self
                           cancelButtonTitle:@"Cancel"
                           destructiveButtonTitle:nil
                           otherButtonTitles:@"Camera",@"Photo Library",@"Clear",nil];
    menu.actionSheetStyle =UIActionSheetStyleBlackTranslucent;

    [menu showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self pickImage:UIImagePickerControllerSourceTypeCamera];
    }else if(buttonIndex ==1){
        [self pickImage:UIImagePickerControllerSourceTypePhotoLibrary];
    }else if(buttonIndex==2){
        self.image.image = nil;
        self.receipt.image = nil;
        self.receipt.isImageEdit = YES;
        self.receipt.filename=@"";
    }
}
-(void)save{
    [self.textNote resignFirstResponder];
    if (self.receipt.receiptId>0){
        if (![self.receipt.note isEqualToString:self.textNote.text]){
            self.receipt.isNoteEdit = YES;
            self.receipt.note = self.textNote.text;
        }
    }else{
        self.receipt.isNoteEdit = ![self.textNote.text isEqualToString:@""];
        self.receipt.note = self.textNote.text;
    }
    
    
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_SAVE_RECEIPT object:self.receipt];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo;
{
    if (!error){
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:@"Image written to photo album"delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }else{
        UIAlertView *av=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error writing to photo album: %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [av show];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.image.image =[info valueForKey:UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    self.receipt.image =[self scaleToSize:self.image.image size:CGSizeMake(320, 480)];
    self.receipt.isImageEdit=YES;
   
}

- (void) pickImage:(UIImagePickerControllerSourceType )sourceType
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = sourceType;
    ipc.delegate =self;
    ipc.allowsEditing =NO;
    if ([AppDevice isIphone]){
        [self presentViewController:ipc animated:YES completion:nil];
    }else{
        _popoverController = [[UIPopoverController alloc] initWithContentViewController:ipc];
        [_popoverController presentPopoverFromRect:CGRectMake(0, 0, 200 , 200) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }

}


@end
