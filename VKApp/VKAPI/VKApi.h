//
//  VKApi.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol VKApi <NSObject>

@required
@optional
- (void)vkontakteDidFinishGettinUserInfo:(NSDictionary *)parsedDictionary;
- (void)vkontakteDidFinishGettinUserFriends:(NSArray *)array;
- (void)vkontakteDidFailedWithError:(NSError *)eror;
- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)postToWallDict;
- (void)vkontakteDidFinishLogOut:(id)self;
@end

@interface VKApi : NSObject
{
    NSString *appid;
    NSString *token;
}
@property (nonatomic, assign) id <VKApi> delegate;

- (id)initWithAppId: (NSString *) appID withToken:(NSString *) apptoken;
- (void)getUserInfoWithUID:(NSString *)userUID;
- (void)getUserFriendsWithUID:(NSString *)userUID;
- (void)postImageToWall:(UIImage *)image text:(NSString *)message link:(NSURL *)url;
- (void)logout;
@end

