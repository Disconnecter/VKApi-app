//
//  VKFriendsViewController.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKFriendsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic,retain) NSArray *userInfos;
@end
