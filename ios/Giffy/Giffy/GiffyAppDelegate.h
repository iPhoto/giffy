//
//  GiffyAppDelegate.h
//  Giffy
//
//  Created by Kyle Olivo on 4/12/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthenticationResource.h"

@interface GiffyAppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) AuthenticationResource *authenticationResource;
@property (strong, nonatomic) UIWindow *window;

@end
