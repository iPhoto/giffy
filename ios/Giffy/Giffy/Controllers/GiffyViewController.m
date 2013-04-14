//
//  GiffyViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GiffyViewController.h"


@interface GiffyViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (strong, nonatomic) OverlayViewController *overlayViewController;

@property (strong, nonatomic) NSMutableArray *capturedImages;

- (IBAction)imageLibraryAction:(id)sender;
- (IBAction)cameraAction:(id)sender;

@end

@implementation GiffyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.overlayViewController = [[OverlayViewController alloc] initWithNibName:@"OverlayViewController" bundle:nil];
    
    self.overlayViewController.delegate = self;
    
    self.capturedImages = [NSMutableArray array];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.toolbar.items.count];
        [toolbarItems addObjectsFromArray:self.toolbar.items];
        //[toolbarItems removeObjectAtIndex:2];
        [self.toolbar setItems:toolbarItems animated:NO];
    } else {
        [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
    }
}

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    if (self.imageView.isAnimating)
        [self.imageView stopAnimating];
    
    if (self.capturedImages.count > 0)
        [self.capturedImages removeAllObjects];
    
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentViewController:self.overlayViewController.imagePickerController animated:YES completion:NULL];
    }
}

- (IBAction)imageLibraryAction:(id)sender
{
    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (IBAction)cameraAction:(id)sender
{
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

- (void)didTakePicture:(UIImage *)picture
{
    [self.capturedImages addObject:picture];
}

- (void)didFinishWithCamera
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            self.imageView.animationImages = self.capturedImages;
            
            if (self.capturedImages.count > 0)
                [self.capturedImages removeAllObjects];
            
            self.imageView.animationDuration = 0.5;
            self.imageView.animationRepeatCount = 0;
            [self.imageView startAnimating];
        }
    }
}

@end
