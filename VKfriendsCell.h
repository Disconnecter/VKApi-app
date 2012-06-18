//
//  VKfriendsCell.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKfriendsCell : UITableViewCell
{
    IBOutlet UILabel *userBdate;
    IBOutlet UIButton *online;
    IBOutlet UILabel *userName;
    IBOutlet UIImageView *userAvatar;
}
@property (nonatomic, assign) int index;
- (void)setWithUserInfo:(NSDictionary *)userInfo;

@end
