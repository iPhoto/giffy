//
//  AuthenticationResource.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RegisterModel.h"
#import "ResourceBase.h"
#import "UserCredentials.h"

@class AuthenticationResource;

@protocol AuthenticationResourceDelegate <NSObject>

@required

-(void)authenticationResourceIsMissingCredentials:(AuthenticationResource*)resource;
-(void)authenticationResource:(AuthenticationResource*)resource DidFailToLoginWithCredentials:(UserCredentials*)credentials;

@end

@interface AuthenticationResource : ResourceBase

@property (strong, atomic) UserCredentials* currentCredentials;
@property (weak, atomic) id<AuthenticationResourceDelegate> delegate;

-(BOOL)addCredentialsInRequest:(NSMutableURLRequest*)request;
-(BOOL)loginWithCredentials:(UserCredentials*)credentials;
-(void)logout;
-(BOOL)registerUser:(RegisterModel*)registerModel;
-(BOOL)verifyStoredCredentials;

@end
