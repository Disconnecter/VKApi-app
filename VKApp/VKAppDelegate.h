//
//  VKAppDelegate.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VKAppDelegate : UIResponder <UIApplicationDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *viewController;

@end
