//
//  LoginRelocateeController.m
//  ExpenseReport
//
//  Created by Fu Steven on 6/25/13.
//  Copyright (c) 2013 Fu Steven. All rights reserved.
//

#import "LoginRelocateeController.h"

@interface LoginRelocateeController (){
    int _perosnId;
    int _userId;
    id _list;
    id _currentRelocatee;
}

@end

@implementation LoginRelocateeController

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(bindRelocatee)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"login_bg"]];
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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    id relocatee = [_list objectAtIndex:indexPath.row];
    cell.textLabel.text = relocatee[@"FirstName"];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _currentRelocatee =[_list objectAtIndex:indexPath.row];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    _currentRelocatee = nil;
}


-(void)loginWithPersonId:(int)personId userId:(int)userId{
    _perosnId = personId;
    _userId = userId;
    [AppSettings sharedSettings].userid = _userId;
    NSString *url =[NSString stringWithFormat:@"users/loginMC?personId=%d",_perosnId];
    [[AppSettings sharedSettings].http get:url block:^(id json) {
        if ([[AppSettings sharedSettings] isSuccess:json]){
            _list = json[@"result"];
            
            id    _summaryList = [[NSMutableArray alloc] init];
                
            for (id item in _list) {
                [_summaryList addObject:@{@"key":item[@"FirstName"],@"value":[NSString stringWithFormat:@"%@",item[@"RelocateeID"]]}];
            }
            
            
            [[AppSettings sharedSettings] saveJsonWith:RELOCATEE_LIST data:_summaryList];
            [self.tableView reloadData];
        }
    }];
}
-(void)bindRelocatee{
    if (!_currentRelocatee){
        [[[UIAlertView alloc] initWithTitle:APP_TITLE message:@"Please choose one relocatee" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        return;
    }
    [[AppSettings sharedSettings] login:_currentRelocatee userId:_userId personId:_perosnId];
}
@end
