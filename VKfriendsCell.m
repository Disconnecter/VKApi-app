//
//  VKfriendsCell.m
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import "VKfriendsCell.h"
#import "UIImageView+AFNetworking.h"
@implementation VKfriendsCell
@synthesize index;
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

- (void)setWithUserInfo:(NSDictionary *)userInfo
{
   [userAvatar setImageWithURL:[NSURL URLWithString:[userInfo valueForKey:@"photo_big"]] placeholderImage:[UIImage imageNamed:@"avatar"]];
  
    userName.text = [NSString stringWithFormat:@"%@ %@",[userInfo valueForKey:@"first_name"],[userInfo valueForKey:@"last_name"]];
    if ([userInfo valueForKey:@"bdate"]!= nil)
        userBdate.text = [userInfo valueForKey:@"bdate"];
    if ([[userInfo valueForKey:@"online"] intValue] == 1)
        online.titleLabel.text = @"1";
    else
        online.titleLabel.text = @"0";  
}

- (NSString *) reuseIdentifier 
{
    return [NSString stringWithFormat: @"CellWithCheck_%d", index];
}

- (void)dealloc 
{
    [userAvatar release];
    [userName release];
    [userBdate release];
    [online release];
    [super dealloc];
}
@end
