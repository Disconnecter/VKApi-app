//
//  VKautorization.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol VKautorization <NSObject>

@required
- (void)authCompleteWithAccessToken:(NSString *)accessToken;
@end

@interface VKautorization : UIViewController <UIWebViewDelegate>
{
    id delegate;
    UIWebView *vkWebView;
    NSString *appID;
    
}
@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) UIWebView *vkWebView;
@property (nonatomic, retain) NSString *appID;

@end
