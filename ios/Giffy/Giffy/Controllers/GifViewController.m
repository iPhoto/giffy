//
//  GifViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifViewController.h"
#import "UIImage+animatedGIF.h"

@interface GifViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation GifViewController

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
    self.imageView.image = self.image;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
