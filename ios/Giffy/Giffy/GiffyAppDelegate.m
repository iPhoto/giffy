//
//  GiffyAppDelegate.m
//  Giffy
//
//  Created by Kyle Olivo on 4/12/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GiffyAppDelegate.h"

#import "AuthenticationResource.h"
#import "GifResouce.h"

@interface GiffyAppDelegate() <AuthenticationResourceDelegate>
@end

@implementation GiffyAppDelegate

-(AuthenticationResource*)authenticationResource
{
    if (!_authenticationResource)
    {
        _authenticationResource = [[AuthenticationResource alloc] init];
        _authenticationResource.delegate = self;
    }
    
    return _authenticationResource;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    dispatch_queue_t dQueue = dispatch_queue_create("Login Queue", NULL);
    dispatch_async(dQueue, ^{
        
//        RegisterModel *registerModel = [[RegisterModel alloc] init];
//        registerModel.userName = @"test3";
//        registerModel.password = @"password1";
//        registerModel.confirmPassword = @"password1";
//        BOOL success1 = [self.authenticationResource registerUser:registerModel];
//        
//        if(success1)
//        {
//        }
        
        UserCredentials *credentials = [[UserCredentials alloc] initWithUserName:@"test" AndPassword:@"password"];
        BOOL success = [self.authenticationResource loginWithCredentials:credentials];
        if(!success)
        {
            // TODO
        }
        else
        {
            GifResouce* resource = [[GifResouce alloc] init];
            BuilderId* builderId = [resource start];
            if(builderId)
            {
                GifComponent *component = [[GifComponent alloc] init];
                component.builderId = builderId;
                
                UIImage* image = [UIImage imageNamed:@"Default.png"];
                
                component.imageData = UIImagePNGRepresentation(image);
                component.order = 1;
                BOOL didAdd = [resource add:component];
                if (didAdd)
                {
                }
                
                GifContainer *container1 = [resource finish:builderId];
                if (container1)
                {
                    
                }
                
                BOOL result = [resource addName:@"Foo" description:@"My giffy gif" toContainer:container1.idValue];
                if(result)
                {
                }

                
                GifContainer *container2 = [resource get:container1.idValue];
                if (container2)
                {
                    
                }
                
                NSArray *allContainers = [resource get];
                if (allContainers)
                {
                }
            }
        }
    });

    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - AuthenticationResourceDelegate members

-(void)authenticationResource:(AuthenticationResource *)resource DidFailToLoginWithCredentials:(UserCredentials *)credentials
{
    // TODO: Notify the user that we could not login with their credentials. Maybe prompt them for a new username/password.
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Credentials"
                                                    message:@"You must provide a valid username and password."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(void)authenticationResourceIsMissingCredentials:(AuthenticationResource *)resource
{
    // TODO: Notify the user that we do not have credentials for them and they will need to register
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Credentials Found"
                                                    message:@"Please register for a new account."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
