//
//  VKpostViewController.h
//  VKApp
//
//  Created by Sergey Zabolotnyy on 6/18/12.
//  Copyright (c) 2012 softtechnics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VKApi.h"
@interface VKpostViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, VKApi, UITextFieldDelegate>
{
    UIImagePickerController *imgPicker;
    IBOutlet UIImageView *image;
    IBOutlet UITextField *textForPost;
}
- (IBAction)choseImagePresed:(UIButton *)sender;
- (IBAction)postClicked:(UIButton *)sender;
@end
