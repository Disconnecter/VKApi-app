//
//  VKFriendsViewController.m
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import "VKFriendsViewController.h"
#import "VKfriendsCell.h"
@interface VKFriendsViewController ()

@end

@implementation VKFriendsViewController

@synthesize userInfos;

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
    // Do any additional setup after loading the view from its nib.
      self.navigationController.navigationBarHidden = NO;  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userInfos count];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellWithCheckId = [NSString stringWithFormat: @"CellWithCheck_%d", indexPath.row];
    
    VKfriendsCell *cell = [tableView dequeueReusableCellWithIdentifier:cellWithCheckId];
    if (cell == nil) 
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"VKfriendsCell" 
                                              owner:self 
                                            options:nil] lastObject];
        cell.index = indexPath.row;
        [cell setWithUserInfo:[userInfos objectAtIndex:indexPath.row]];
    }
    
    
    
    return cell;
}

- (void)dealloc 
{
    [userInfos release];
    [super dealloc];
}
@end
