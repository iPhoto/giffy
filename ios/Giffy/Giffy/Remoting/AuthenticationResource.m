//
//  AuthenticationResource.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "AuthenticationResource.h"
#import "ResourceBase.h"

@implementation AuthenticationResource

#define kCredentials @"AuthenticationResource_Credentials"
#define kUserName @"UserName"
#define kPassword @"Password"

-(BOOL)addCredentialsInRequest:(NSMutableURLRequest *)request
{
    if(![self hasStoredCredentials])
        return NO;
    
    [request addValue:self.currentCredentials.userName forHTTPHeaderField: kLoginRequestUserNameKey];
    [request addValue:self.currentCredentials.authenticationToken forHTTPHeaderField: kLoginRequestUserNameKey];
    return YES;
}

-(BOOL)hasStoredCredentials
{
    return self.currentCredentials || [self loadCredentials];
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
    
    self.currentCredentials = credentials;
    
    return YES;
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
    
    Response* response =  [self makeRequestFromController:kLoginControllerName
                                                 WithType:RequestTypePost
                                                AndValues:@{@"UserName" : credentials.userName, @"Password" : credentials.password}];
    
    if (!response.success)
    {
        NSLog(@"Login was not successful: %@", [response errorMessage]);
        return NO;
    }
    
    NSLog(@"Login was successful");
    
    self.currentCredentials = credentials;
    [self storeCredentials];
    
    NSUInteger count = [response.data count];
    NSAssert(count == 1, @"The login response should have one data result.");
    
    if (count == 0)
    {
        NSLog(@"No login data returned");
        return NO;
    }
    
    id data = response.data[0];
    if (![data isKindOfClass:[NSDictionary class]])
    {
         NSLog(@"The login response data is not in the correct format.");
        return NO;
    }
    
    NSDictionary* dataDictionary = (NSDictionary*)data;
    
    NSString* userName = dataDictionary[kLoginResponseUserNameKey];
    NSString* token = dataDictionary[kLoginResponseTokenKey];
    NSAssert([userName isEqualToString:credentials.userName], @"The user name in the response did not match.");
 
    credentials.authenticationToken = token;
    
    return YES;
}

-(void)logout
{
    self.currentCredentials = nil;
    
    // TODO: Use keychain here
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCredentials];
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

@end
