//
//  GiffyAppDelegate.m
//  Giffy
//
//  Created by Kyle Olivo on 4/12/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GiffyAppDelegate.h"

#import "GifManager.h"
#import "GifRepository.h"

@interface GiffyAppDelegate() <AuthenticationResourceDelegate>
@end

@implementation GiffyAppDelegate

@synthesize authenticationResource = _authenticationResource;

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
        GifRepository *repository = [[GifRepository alloc] init];
        
        NSArray *managers = [repository getCompletedGifManagers];
        
        GifManager *manager = [managers objectAtIndex:0];
        manager.name = @"Test update";
        [manager update];
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
    // TODO: Notify the user that we could not login with their credentials. Maybe prompt them for a new username/password
}

-(void)authenticationResourceIsMissingCredentials:(AuthenticationResource *)resource
{
    // TODO: Notify the user that we do not have credentials for them and they will need to register
}

@end
