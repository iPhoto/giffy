//
//  OverlayViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "OverlayViewController.h"

@interface OverlayViewController ()

@property (nonatomic) SystemSoundID tickSound;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *takePictureButton;

@property (nonatomic) NSInteger photoCount;

@property (strong, nonatomic) NSTimer *tickTimer;
@property (strong, nonatomic) NSTimer *cameraTimer;

- (IBAction)done:(id)sender;
- (IBAction)takePhotos:(id)sender;

@end

@implementation OverlayViewController

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:
                                                    [[NSBundle mainBundle] pathForResource:@"tick"
                                                                                    ofType:@"aiff"]],
                                         &_tickSound);
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (void)setupImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    self.imagePickerController.sourceType = sourceType;
    
    if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        self.imagePickerController.showsCameraControls = NO;
        self.imagePickerController.cameraViewTransform = CGAffineTransformMakeScale(1.0, 1.03);
        
        if ([[self.imagePickerController.cameraOverlayView subviews] count] == 0)
        {
            CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
            CGRect newFrame = CGRectMake(0.0, CGRectGetHeight(overlayViewFrame) - self.view.frame.size.height - 10.0, CGRectGetWidth(overlayViewFrame), self.view.frame.size.height + 10.0);
            self.view.frame = newFrame;
            [self.imagePickerController.cameraOverlayView addSubview:self.view];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    
//    [self.cameraTimer invalidate];
//    _cameraTimer = nil;
//    
//    [self.tickTimer invalidate];
//    _tickTimer = nil;
//}

- (void)finishAndUpdate
{
    [self.delegate didFinishWithCamera];
    
    self.doneButton.enabled = YES;
    self.takePictureButton.enabled = YES;
}

- (IBAction)done:(id)sender {
    if (![self.cameraTimer isValid])
    {
        [self finishAndUpdate];
    }
}

#define PHOTOS_PER_GIF 15

- (void)timedPhotoFire:(NSTimer *)timer {
    if (_photoCount < PHOTOS_PER_GIF) {
        [self.imagePickerController takePicture];
        _photoCount++;
    }
    else
    {
        [self stopTimer];
    }
}

- (void)tickFire:(NSTimer *)timer {
    AudioServicesPlaySystemSound(self.tickSound);
}

- (void)stopTimer {
    if ([self.cameraTimer isValid])
    {
        [self.cameraTimer invalidate];
        _cameraTimer = nil;
        
        [self finishAndUpdate];
    }
}

- (IBAction)takePhotos:(id)sender {
    if (![self.cameraTimer isValid]) {
        self.doneButton.enabled = NO;
        self.takePictureButton.enabled = NO;
        
        _photoCount = 0;
        
        _cameraTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(timedPhotoFire:) userInfo:nil repeats:YES];
        [self.cameraTimer fire];
    } else {
       [self stopTimer]; 
    }
}

UIImage* resizeImage(UIImage *image)
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGSize imageSize = CGSizeMake(actualWidth, actualHeight);
    UIImage *resizedImage = [image resizedImage:imageSize interpolationQuality:kCGInterpolationHigh];
    return resizedImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    image = resizeImage(image);
    
    if (self.delegate)
        [self.delegate didTakePicture:image];
    
    if (![self.cameraTimer isValid])
        [self finishAndUpdate];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate didFinishWithCamera];
}

@end
