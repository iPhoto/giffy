//
//  AuthenticationResource.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "AuthenticationResource.h"
#import "Authentication.h"
#import "ResourceBase.h"

@implementation AuthenticationResource

#define kCredentials @"AuthenticationResource_Credentials"
#define kUserName @"UserName"
#define kPassword @"Password"

-(BOOL)addCredentialsInRequest:(NSMutableURLRequest *)request
{
    if(![self verifyStoredCredentials])
        return NO;
    
    [request addValue:self.currentCredentials.userName forHTTPHeaderField: kLoginRequestUserNameKey];
    [request addValue:self.currentCredentials.authenticationToken forHTTPHeaderField: kLoginRequestAuthenticationTokenKey];
    return YES;
}

-(BOOL)loadCredentials
{
    if (self.currentCredentials)
        return YES;
    
    // TODO: Use keychain here
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* credentialsDictionary = [userDefaults dictionaryForKey:kCredentials];
    
    if(!credentialsDictionary)
    {
        if(self.delegate)
            [self.delegate authenticationResourceIsMissingCredentials:self];
        
        return NO;
    }
    
    UserCredentials* credentials = [[UserCredentials alloc] init];
    
    credentials.userName = credentialsDictionary[kUserName];
    credentials.password = credentialsDictionary[kPassword];
    
    return [self loginWithCredentials: credentials];
}

-(BOOL)loginWithCredentials:(UserCredentials *)credentials
{
    if(![self loginWithCredentialsHelper:credentials] && self.delegate )
        [self.delegate authenticationResource:self DidFailToLoginWithCredentials:credentials];
    
    return YES;
}

-(BOOL)loginWithCredentialsHelper:(UserCredentials *)credentials
{
    if(!credentials.userName || !credentials.password)
        return NO;
    
    Response* response =  [self makeRequestFromController:kLoginController_Name
                                                 type:RequestTypePost
                                                values:@{kUserCredentials_UserName_Key : credentials.userName, kUserCredentials_Password_Key : credentials.password}];
    
    if (!response.success)
    {
        NSLog(@"Login was not successful: %@", response.message);
        return NO;
    }
    
    Authentication* authentication = [AuthenticationResource authenticationFromResponse:response];
    if(!authentication)
        return NO;
    
    NSLog(@"Login was successful");
    NSAssert([authentication.userName isEqualToString:credentials.userName], @"The user name in the response did not match.");
    
    credentials.authenticationToken = authentication.token;
    self.currentCredentials = credentials;
    
    [self storeCredentials];
    
    return YES;
}

-(void)logout
{
    self.currentCredentials = nil;
    
    // TODO: Use keychain here
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kCredentials];
    [userDefaults synchronize];
}

-(BOOL)registerUser:(RegisterModel*)registerModel
{
    if(self.currentCredentials)
        self.currentCredentials = nil;
    
    NSDictionary *values = @{kRegisterModel_UserName_Key : registerModel.userName,
                             kRegisterModel_Password_Key : registerModel.password,
                             kRegisterModel_ConfirmPassword_Key : registerModel.confirmPassword};
    
    Response* response =  [self makeRequestFromController:kRegisterController_Name
                                                    type:RequestTypePost
                                                  values:values];
    
    if (!response.success)
    {
        NSLog(@"Registration was not successful: %@", response.message);
        return NO;
    }
    
    BOOL result = [AuthenticationResource boolFromResponse:response];
    if(!result)
        return NO;
    
    NSLog(@"Registration was successful");
    
    UserCredentials* credentials = [[UserCredentials alloc] initWithUserName:registerModel.userName AndPassword:registerModel.password];
    return [self loginWithCredentials:credentials];
}

-(void)storeCredentials
{
    if (!self.currentCredentials)
        return;
    
    // TODO: Use keychain here
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary* credentialsDictionary = @{kUserName : self.currentCredentials.userName,
                                            kPassword : self.currentCredentials.password};
    
    [userDefaults setValue:credentialsDictionary forKey:kCredentials];
    [userDefaults synchronize];
}

-(BOOL)verifyStoredCredentials
{
    return self.currentCredentials || [self loadCredentials];
}

@end
