//
//  GiffyViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GiffyViewController.h"
#import "GifManager.h"
#import "PreviewViewController.h"

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

- (void)gifManagerDidFinishCreatingGif:(GifManager *)manager {
    NSLog(@"Gif Manager reported that it completed the gif.");
    self.imageView.image = manager.gif;
    [self.imageView setNeedsDisplay];
}

- (void)didFinishWithCamera
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
    if ([self.capturedImages count] > 0)
    {
        if ([self.capturedImages count] == 1)
        {
            [self.imageView setImage:[self.capturedImages objectAtIndex:0]];
        }
        else
        {
            GifManager *manager = [[GifManager alloc] initWithDelegate:self];
            for (UIImage *cameraImage in self.capturedImages) {
                                [manager addImage:cameraImage];
            }
            [manager finish];
            
            PreviewViewController* previewViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewView"];
            previewViewController.delegate = self;
            previewViewController.gifManager = manager;
            previewViewController.preview = [self.capturedImages objectAtIndex:0];
            [self presentViewController:previewViewController animated:NO completion:nil];
        }
    }
}

-(void)previewViewWasCancelled:(PreviewViewController *)sender
{
    // TODO: Remove the GIF from the server
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)previewViewWasUpdated:(PreviewViewController *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
