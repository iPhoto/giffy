//
//  OverlayViewController.h
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

@protocol OverlayViewControllerDelegate

- (void)didTakePicture:(UIImage *)picture;
- (void)didFinishWithCamera;

@end

@interface OverlayViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    id <OverlayViewControllerDelegate> delegate;
}

@property (strong, nonatomic) id <OverlayViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType;

@end