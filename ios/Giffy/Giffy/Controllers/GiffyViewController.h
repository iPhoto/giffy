//
//  GiffyViewController.h
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OverlayViewController.h"
#import "UIImage+animatedGIF.h"
#import "GifManager.h"
#import "PreviewViewController.h"

@interface GiffyViewController : UIViewController <UIImagePickerControllerDelegate, OverlayViewControllerDelegate, GifManagerDelegate, PreviewViewControllerDelegate>
@end