//
//  ItemsPickerController.m
//  ExpenseReport
//
//  Created by Steven Fu on 7/8/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "ItemsPickerController.h"

@interface ItemsPickerController (){
    NSArray *_list;
    id _selectedItem;
    UITableViewCell *_currentCell;
}

@end

@implementation ItemsPickerController

-(id)initWithList:(NSArray *)list{
    self =[super initWithStyle:UITableViewStyleGrouped];
    if (self){
        _list = list;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
}

-(void)done{
    if (_selectedItem){
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGE_CHOOSE_ITEM object:nil userInfo:@{@"key":self.key,@"value":_selectedItem}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please choose one item" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==Nil){
        cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    id item = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = item[@"Description"];
    if (self.selected==[item[self.fieldName] intValue]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _selectedItem = item;
        _currentCell = cell;
    }else{
        cell.accessoryType =UITableViewCellAccessoryNone;
    }
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType==UITableViewCellAccessoryCheckmark){
        cell.accessoryType = UITableViewCellAccessoryNone;
        _selectedItem =nil;
        _currentCell = nil;
        self.selected =0;
    }else{
        if (_currentCell){
            _currentCell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        _selectedItem =[_list objectAtIndex:indexPath.row];
        _currentCell = cell;
        self.selected = _selectedItem[self.fieldName];
    }
}


@end
