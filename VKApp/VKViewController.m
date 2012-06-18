//
//  VKViewController.m
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import "VKViewController.h"
#import "VKautorization.h"
#import "VKApi.h"
#import "VKFriendsViewController.h"
#import "VKpostViewController.h"
#define myAppID @"2998217"
@interface VKViewController ()

@end

@implementation VKViewController
NSString *appToken;

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
}

- (void)viewWillAppear:(BOOL)animated
{
  self.navigationController.navigationBarHidden = YES;  
}

- (void)viewDidUnload
{
    [userName release];
    userName = nil;
    [uesrAvatar release];
    uesrAvatar = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)loginButtonPressed:(UIButton *)sender 
{
    VKautorization *vkAutoriz = [[[VKautorization alloc] init] autorelease];
    vkAutoriz.appID = myAppID;
    vkAutoriz.delegate = self;
    [self presentModalViewController:vkAutoriz animated:YES];
}



- (void)authCompleteWithAccessToken:(NSString *)token 
{
    appToken = token;
    NSString *vkAccessUserId = [[NSUserDefaults standardUserDefaults] valueForKey:@"VKAccessUserId"];
    
    VKApi *vk = [[[VKApi alloc] initWithAppId:myAppID withToken:appToken]autorelease];
    vk.delegate = self;
    [vk getUserInfoWithUID:vkAccessUserId];
}

- (IBAction)logoutButtonPressed:(UIButton *)sender 
{
    VKApi *vk = [[[VKApi alloc] initWithAppId:myAppID withToken:appToken] autorelease];
    vk.delegate = self;
    [vk logout];
}

- (IBAction)getFriendsButtonPressed:(UIButton *)sender 
{
    VKApi *vk = [[[VKApi alloc] initWithAppId:myAppID withToken:appToken] autorelease];
    vk.delegate = self;
    [vk getUserFriendsWithUID:[[NSUserDefaults standardUserDefaults] valueForKey:@"VKAccessUserId"]];
}

- (IBAction)postPressed:(id)sender 
{
    VKpostViewController *postVc = [[[VKpostViewController alloc] initWithNibName:@"VKpostViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:postVc animated:YES];
}

-(void) vkontakteDidFinishGettinUserInfo:(NSDictionary *)parsedDictionary
{
    userName.text = [NSString stringWithFormat:@"%@ %@",[parsedDictionary valueForKey:@"first_name"],[parsedDictionary valueForKey:@"last_name"]];
    uesrAvatar.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[parsedDictionary valueForKey:@"photo_big"]]]];
}

- (void)vkontakteDidFinishGettinUserFriends:(NSArray *)array
{
    VKFriendsViewController *friends = [[[VKFriendsViewController alloc]initWithNibName:@"VKFriendsViewController" bundle:nil] autorelease];
    friends.userInfos = array;
    [self.navigationController pushViewController:friends animated:YES];
}

- (void)vkontakteDidFailedWithError:(NSError *)eror
{
    NSLog(@"Error %@",  eror.localizedDescription);
}

- (void)vkontakteDidFinishLogOut:self
{
    uesrAvatar.image = nil;
    userName.text = @"";
}

- (void)dealloc 
{
    [userName release];
    [uesrAvatar release];
    [super dealloc];
}
@end
