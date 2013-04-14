//
//  RegisterViewController.m
//  Giffy
//
//  Created by Kyle Olivo on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "RegisterViewController.h"
#import "GiffyAppDelegate.h"
#import "GiffyViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *confirmPassword;
@end

@implementation RegisterViewController

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, _activeField.frame.origin.y-kbSize.height);
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    GiffyAppDelegate *appDelegate = (GiffyAppDelegate *)[[UIApplication sharedApplication] delegate];
    AuthenticationResource *authenticationResource = appDelegate.authenticationResource;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle bundleForClass:[self class]]];
    GiffyViewController *giffyView = [storyboard instantiateViewControllerWithIdentifier:@"GiffyViewController"];
    if ([authenticationResource verifyStoredCredentials]) {
        [self.navigationController pushViewController:giffyView animated:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self registerForKeyboardNotifications];
    //GiffyAppDelegate *mainDelegate = (GiffyAppDelegate *)[[[UIApplication sharedApplication]delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)checkCredentials
{
//
//    dispatch_queue_t dQueue = dispatch_queue_create("Login Queue", NULL);
//    dispatch_async(dQueue, ^{
//        UserCredentials *credentials = [[UserCredentials alloc] initWithUserName:@"test" AndPassword:@"password"];
//        BOOL success = [self.authenticationResource loginWithCredentials:credentials];
//        if(!success)
//            {
//                // TODO
//            }
//    });
//
//    myDBManager = mainDelegate.myDBManager;
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    BOOL performSegue = NO;
    GiffyAppDelegate *appDelegate = (GiffyAppDelegate *)[[UIApplication sharedApplication] delegate];
    AuthenticationResource *authenticationResource = appDelegate.authenticationResource;
    if ([self.username.text isEqualToString:@""] || [self.password.text isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                                                        message:@"You must provide a username and password."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (![self.password.text isEqualToString:self.confirmPassword.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                                                        message:@"The passwords you entered do not match."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        RegisterModel *registerModel = [[RegisterModel alloc]
                                        initWithUserName:self.username.text AndPassword:self.password.text AndConfimation:self.confirmPassword.text];
        BOOL success = [authenticationResource registerUser:registerModel];
        if(success)
        {
            performSegue = YES;
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Register"
                                                            message:@"Unable to register at this time, please try again later."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
    }
    return performSegue;
}

@end
