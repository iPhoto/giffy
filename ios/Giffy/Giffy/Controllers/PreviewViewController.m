//
//  PreviewViewController.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "PreviewViewController.h"

@interface PreviewViewController () <GifManagerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *descriptionField;
@property (weak, nonatomic) IBOutlet UIImageView *previewView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *waitIndicator;

@end

@implementation PreviewViewController

- (void)setGifManager:(GifManager *)gifManager
{
    [_gifManager removeDelegate:self];
    _gifManager = gifManager;
    [_gifManager addDelegate:self];
    [self updateUI];
}

- (void)setPreview:(UIImage *)preview
{
    _preview = preview;
    [self updateUI];
}

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
	[self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateUI
{
    self.previewView.image = self.preview;
    
    if (self.gifManager)
    {
        self.titleField.text = self.gifManager.name;
        self.descriptionField.text = self.gifManager.gifDescription;
    }
}

- (IBAction)cancel:(id)sender {
    // TODO: Remove the GIF from the server
    self.gifManager = nil;
    
    [self.delegate previewViewWasCancelled:self];
}

- (IBAction)saveInformation:(id)sender {
    
    if (self.titleField.text == self.gifManager.name &&
        self.descriptionField.text == self.gifManager.gifDescription)
    {
        [self onPreviewComplete];
        return;
    }
    
    [self disableUI];
    
    self.gifManager.name = self.titleField.text;
    self.gifManager.gifDescription = self.descriptionField.text;
    [self.gifManager update];
}

- (void)disableUI {
    self.saveButton.enabled = NO;
    [self.waitIndicator startAnimating];
}

- (void)enableUI {
    self.saveButton.enabled = YES;
    [self.waitIndicator stopAnimating];
}

- (void)onPreviewComplete
{
    self.gifManager = nil;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:@"TODO: Transition to next screen"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - GifManagerDelegate methods

-(void)gifManager:(GifManager *)manager didReceiveError:(NSString *)errorMessage
{
    [self enableUI];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

-(void)gifManagerDidFinishUpdating:(GifManager *)manager
{
    [self enableUI];
    [self onPreviewComplete];
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
