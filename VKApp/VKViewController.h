//
//  VKViewController.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKApi.h"
@interface VKViewController : UIViewController <VKApi>
{
    IBOutlet UILabel *userName;
    IBOutlet UIImageView *uesrAvatar;
}

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (void)authCompleteWithAccessToken:(NSString *)token;
- (IBAction)logoutButtonPressed:(UIButton *)sender;
- (IBAction)getFriendsButtonPressed:(UIButton *)sender;
- (IBAction)postPressed:(id)sender;
@end
