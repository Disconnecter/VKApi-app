//
//  VKApi.m
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/15/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import "VKApi.h"
#import "JSON.h"

@implementation VKApi

@synthesize delegate;

BOOL _isCaptcha;
- (void)getCaptcha 
{
    NSString *captcha_img = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_img"];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Введите код:\n\n\n\n\n"
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    UIImageView *imageView = [[[UIImageView alloc] initWithFrame:CGRectMake(12.0, 45.0, 130.0, 50.0)] autorelease];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:captcha_img]]];
    [myAlertView addSubview:imageView];
    
    UITextField *myTextField = [[[UITextField alloc] initWithFrame:CGRectMake(12.0, 110.0, 260.0, 25.0)] autorelease];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.tag = 33;
    
    [myAlertView addSubview:myTextField];
    [myAlertView show];
    [myAlertView release];
}


- (NSDictionary *)sendRequest:(NSString *)reqURl withCaptcha:(BOOL)captcha 
{
    if(captcha == YES)
    {
        NSString *captcha_sid = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_sid"];
        NSString *captcha_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_user"];
        reqURl = [reqURl stringByAppendingFormat:@"&captcha_sid=%@&captcha_key=%@", captcha_sid, [self URLEncodedString: captcha_user]];
    }
    NSLog(@"Sending request: %@", reqURl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:60.0]; 
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if(responseData)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData 
                                                         encoding:NSUTF8StringEncoding];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        NSDictionary *dict = [parser objectWithString:responseString];
        [parser release];
        [responseString release];
        
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        if([errorMsg isEqualToString:@"Captcha needed"])
        {
            _isCaptcha = YES;
            NSString *captcha_sid = [[dict objectForKey:@"error"] objectForKey:@"captcha_sid"];
            NSString *captcha_img = [[dict objectForKey:@"error"] objectForKey:@"captcha_img"];
            [[NSUserDefaults standardUserDefaults] setObject:captcha_img forKey:@"captcha_img"];
            [[NSUserDefaults standardUserDefaults] setObject:captcha_sid forKey:@"captcha_sid"];
            [[NSUserDefaults standardUserDefaults] setObject:reqURl forKey:@"request"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self getCaptcha];
        }
        
        return dict;
    }
    return nil;
}

- (NSDictionary *)sendPOSTRequest:(NSString *)reqURl withImageData:(NSData *)imageData 
{
    NSLog(@"Sending request: %@", reqURl);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl] 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
                                                       timeoutInterval:60.0]; 
    [request setHTTPMethod:@"POST"]; 
    
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = [(NSString*)CFUUIDCreateString(nil, uuid) autorelease];
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];        
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSDictionary *dict;
    if(responseData)
    {
        NSString *responseString = [[NSString alloc] initWithData:responseData 
                                                         encoding:NSUTF8StringEncoding];
        SBJsonParser *parser = [SBJsonParser new];
        dict = [parser objectWithString:responseString];
        [parser release];
        [responseString release];
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        return dict;
    }
    return nil;
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)str,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8);
    [result autorelease];
	return result;
}

- (id)initWithAppId:(NSString *)appID withToken:(NSString *)apptoken
{
    self = [super init];
    if (self) 
    {
        appid = appID;
        token = apptoken;
    }
    return self;
}

- (void)getUserInfoWithUID:(NSString *)userUID
{    
    NSMutableString *requestString = [[NSMutableString alloc] init];
	[requestString appendFormat:@"%@/", @"https://api.vk.com/method"];
    [requestString appendFormat:@"%@?", @"getProfiles"];
    [requestString appendFormat:@"uid=%@&", userUID];
    NSMutableString *fields = [[NSMutableString alloc] init];
    [fields appendString:@"sex,bdate,photo,photo_big"];
    [requestString appendFormat:@"fields=%@&", fields];
	[fields release];
    [requestString appendFormat:@"access_token=%@", token];
    
	NSURL *url = [NSURL URLWithString:requestString];
	[requestString release];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
	NSData *response = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:nil 
														 error:nil];
	NSString *responseString = [[NSString alloc] initWithData:response 
                                                     encoding:NSUTF8StringEncoding];
	NSLog(@"%@",responseString);
    
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *parsedDictionary = [parser objectWithString:responseString];
	[parser release];
	[responseString release];
    
    NSArray *array = [parsedDictionary objectForKey:@"response"];
    
    if (array != nil) 
    {
        parsedDictionary = [array objectAtIndex:0];
        //[parsedDictionary setValue:self.email forKey:@"email"];
        
        if ([self.delegate respondsToSelector:@selector(vkontakteDidFinishGettinUserInfo:)])
        {
            [self.delegate vkontakteDidFinishGettinUserInfo:parsedDictionary];
        }
    }
    else
    {        
        NSDictionary *errorDict = [parsedDictionary objectForKey:@"error"];
        
       if ([self.delegate respondsToSelector:@selector(vkontakteDidFailedWithError:)])
        {
            NSError *error = [NSError errorWithDomain:@"http://api.vk.com/method" 
                                                 code:[[errorDict objectForKey:@"error_code"] intValue]
                                             userInfo:errorDict];
            
            if (error.code == 5) 
            {
                [self logout];
            }
            
            [self.delegate vkontakteDidFailedWithError:error];
        }
    }
}

- (void)logout
{        
        NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray* vkCookies1 = [cookies cookiesForURL:
                               [NSURL URLWithString:@"http://api.vk.com"]];
        NSArray* vkCookies2 = [cookies cookiesForURL:
                               [NSURL URLWithString:@"http://vk.com"]];
        NSArray* vkCookies3 = [cookies cookiesForURL:
                               [NSURL URLWithString:@"http://login.vk.com"]];
        NSArray* vkCookies4 = [cookies cookiesForURL:
                               [NSURL URLWithString:@"http://oauth.vk.com"]];
        
        for (NSHTTPCookie* cookie in vkCookies1) 
        {
            [cookies deleteCookie:cookie];
        }
        for (NSHTTPCookie* cookie in vkCookies2) 
        {
            [cookies deleteCookie:cookie];
        }
        for (NSHTTPCookie* cookie in vkCookies3) 
        {
            [cookies deleteCookie:cookie];
        }
        for (NSHTTPCookie* cookie in vkCookies4) 
        {
            [cookies deleteCookie:cookie];
        }

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"VKAccessToken"]) 
        {
            [defaults removeObjectForKey:@"VKAccessToken"];
            [defaults removeObjectForKey:@"VKExpirationDateKey"];
            [defaults removeObjectForKey:@"VKAccessUserId"];
            [defaults synchronize];
            
            // Nil out the session variables to prevent
            // the app from thinking there is a valid session
//            if (nil != [self accessToken]) 
//            {
//                self.accessToken = nil;
//            }
//            if (nil != [self expirationDate]) 
//            {
//                self.expirationDate = nil;
//            }
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(vkontakteDidFinishLogOut:)]) 
        {
            [self.delegate vkontakteDidFinishLogOut:self];
        }
//    }
}

- (void)getUserFriendsWithUID:(NSString *)userUID
{
    if(userUID == nil || token == nil)
        return;
    
    NSMutableString *requestString = [[NSMutableString alloc] init];
	[requestString appendFormat:@"%@/", @"https://api.vk.com/method"];
    [requestString appendFormat:@"%@?", @"friends.get"];
    [requestString appendFormat:@"uid=%@&", userUID];
    NSMutableString *fields = [[NSMutableString alloc] init];
    [fields appendString:@"sex,bdate,photo,photo_big"];
    [requestString appendFormat:@"fields=%@&", fields];
	[fields release];
    [requestString appendFormat:@"access_token=%@", token];
    
	NSURL *url = [NSURL URLWithString:requestString];
	[requestString release];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
	NSData *response = [NSURLConnection sendSynchronousRequest:request 
											 returningResponse:nil 
														 error:nil];
	NSString *responseString = [[NSString alloc] initWithData:response 
                                                     encoding:NSUTF8StringEncoding];
	NSLog(@"%@",responseString);
    
	SBJsonParser *parser = [[SBJsonParser alloc] init];
	NSDictionary *parsedDictionary = [parser objectWithString:responseString];
	[parser release];
	[responseString release];
    
    NSArray *array = [parsedDictionary objectForKey:@"response"];

    if (array != nil && self.delegate && [self.delegate respondsToSelector:@selector(vkontakteDidFinishGettinUserFriends:)]) 
    {
        [self.delegate vkontakteDidFinishGettinUserFriends:array];
    }
}

- (void)postImageToWall:(UIImage *)image text:(NSString *)message link:(NSURL *)url
{
    NSString *userID = [[NSUserDefaults standardUserDefaults] valueForKey:@"VKAccessUserId"];
    
    if(userID == nil || token == nil)
        return;
    
    NSString *getWallUploadServer = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", userID, token];
    
    NSDictionary *uploadServer = [self sendRequest:getWallUploadServer withCaptcha:NO];
    
    NSString *upload_url = [[uploadServer objectForKey:@"response"] objectForKey:@"upload_url"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
    
    NSDictionary *postDictionary = [self sendPOSTRequest:upload_url withImageData:imageData];
    
    NSString *hash = [postDictionary objectForKey:@"hash"];
    NSString *photo = [postDictionary objectForKey:@"photo"];
    NSString *server = [postDictionary objectForKey:@"server"];
    
    NSString *saveWallPhoto = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", 
                               userID, 
                               token,
                               server,
                               photo,
                               hash];
    
    saveWallPhoto = [saveWallPhoto stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *saveWallPhotoDict = [self sendRequest:saveWallPhoto withCaptcha:NO];
    
    NSDictionary *photoDict = [[saveWallPhotoDict objectForKey:@"response"] lastObject];
    NSString *photoId = [photoDict objectForKey:@"id"];
    
    NSString *postToWallLink;
    
    if (url) 
    {
        postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachments=%@,%@", 
                          userID, 
                          token, 
                          [self URLEncodedString:message], 
                          photoId,
                          [url absoluteURL]];
    } 
    else 
    {
        postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", 
                          userID, 
                          token, 
                          [self URLEncodedString:message], 
                          photoId];
    }
    
    NSDictionary *postToWallDict = [self sendRequest:postToWallLink withCaptcha:NO];
    NSString *errorMsg = [[postToWallDict  objectForKey:@"error"] objectForKey:@"error_msg"];
    if(errorMsg) 
    {
        NSDictionary *errorDict = [postToWallDict objectForKey:@"error"];
        
        if ([self.delegate respondsToSelector:@selector(vkontakteDidFailedWithError:)])
        {
            NSError *error = [NSError errorWithDomain:@"http://api.vk.com/method" 
                                                 code:[[errorDict objectForKey:@"error_code"] intValue]
                                             userInfo:errorDict];
            
            if (error.code == 5) 
            {
                [self logout];
            }
            
            [self.delegate vkontakteDidFailedWithError:error];
        }
    } 
    else 
    {
        if (self.delegate && [self.delegate  respondsToSelector:@selector(vkontakteDidFinishPostingToWall:)]) 
        {
            [self.delegate  vkontakteDidFinishPostingToWall:postToWallDict];
        }
    }
}

@end
