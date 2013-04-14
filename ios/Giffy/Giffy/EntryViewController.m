//
//  EntryViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "EntryViewController.h"
#import "GiffyAppDelegate.h"
#import "GiffyViewController.h"

@interface EntryViewController ()
@end

@implementation EntryViewController

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
    GiffyAppDelegate *appDelegate = (GiffyAppDelegate *)[[UIApplication sharedApplication] delegate];
    AuthenticationResource *authenticationResource = appDelegate.authenticationResource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle bundleForClass:[self class]]];
    GiffyViewController *giffyView = [storyboard instantiateViewControllerWithIdentifier:@"GiffyViewController"];
    if ([authenticationResource verifyStoredCredentials]) {
        [self.navigationController pushViewController:giffyView animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
