//
//  VKpostViewController.m
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import "VKpostViewController.h"

@interface VKpostViewController ()

@end

@implementation VKpostViewController

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
    imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate = self;
    imgPicker.allowsImageEditing = YES;
    imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.navigationController.navigationBarHidden = NO;  
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [image release];
    image = nil;
    [textForPost release];
    textForPost = nil;
    [imgPicker release];
    imgPicker = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [image release];
    [textForPost release];
    [imgPicker release];
    [super dealloc];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo 
{
    image.image = img;
    [picker dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)choseImagePresed:(UIButton *)sender 
{
    [self presentModalViewController:imgPicker animated:YES];
}
#define myAppID @"2998217"
- (IBAction)postClicked:(UIButton *)sender 
{
    NSString *VKAccessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"VKAccessToken"];
    VKApi *vk = [[[VKApi alloc] initWithAppId:myAppID withToken:VKAccessToken] autorelease];
    vk.delegate = self;
    [vk postImageToWall:image.image text:textForPost.text link:nil];
}

- (void)vkontakteDidFinishPostingToWall:(NSDictionary *)postToWallDict
{
    NSLog(@"%@",postToWallDict);
}

@end
