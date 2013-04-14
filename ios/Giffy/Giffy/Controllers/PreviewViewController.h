//
//  PreviewViewController.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GifManager.h"

@class PreviewViewController;

@protocol PreviewViewControllerDelegate <NSObject>

@required
-(void)previewViewWasCancelled:(PreviewViewController *)sender;

@end

@interface PreviewViewController : UIViewController

@property (weak, nonatomic) id<PreviewViewControllerDelegate> delegate;
@property (strong, nonatomic) GifManager *gifManager;
@property (strong, nonatomic) UIImage *preview;

@end
