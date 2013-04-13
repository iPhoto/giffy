//
//  ResourceBase.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "ResourceBase.h"
#import "GiffyAppDelegate.h"

#define kBaseUrl @"http://giffy.azurewebsites.net/api/" // TODO Move to config file

#define kResultDataKey @"Data"
#define kResultSuccessKey @"Success"

@interface ResourceBase()

@property (strong, nonatomic) NSSet* controllerUsingQueryString;

@end

@implementation ResourceBase

-(NSSet*)controllerUsingQueryString
{
    if (!_controllerUsingQueryString)
        _controllerUsingQueryString = [[NSSet alloc] initWithArray:@[]];
    
    return _controllerUsingQueryString;
}

-(Response*)makeRequestFromController:(NSString *)controller WithType:(RequestType)requestType AndValues:(NSDictionary *)values
{
    return [self makeRequestFromController:controller WithType:requestType WithAction:nil AndValues:values];
}

-(Response*)makeRequestFromController:(NSString *)controller WithType:(RequestType)requestType WithAction:(NSString *)action AndValues:(NSDictionary *)values
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, controller];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if(![controller isEqualToString:kLoginControllerName])
    {
        GiffyAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        if(![appDelegate.authenticationResource addCredentialsInRequest:request])
            return [ResourceBase responseFromErrorMessage:@"Could not obtain authorization token from server."];
    }
    
    switch(requestType)
    {
        case RequestTypeDelete:
            [request setHTTPMethod:@"DELETE"];
            break;
            
        case RequestTypeGet:
            [request setHTTPMethod:@"GET"];
            break;
            
        case RequestTypePost:
            [request setHTTPMethod:@"POST"];
            break;
            
        case RequestTypePut:
            [request setHTTPMethod:@"PUT"];
            break;
    }
    
    if([self.controllerUsingQueryString containsObject:controller])
    {
        // TODO
    }
    else
    {
        NSError *jsonSerializationError = nil;
        NSData* data = [NSJSONSerialization dataWithJSONObject:values
                                                       options:kNilOptions
                                                         error:&jsonSerializationError];
        
        if (jsonSerializationError)
            return [ResourceBase responseFromError:jsonSerializationError];
        
        [request setHTTPBody: data];
    }
    
    NSError *connectionError = nil;
    NSURLResponse *urlResponse = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                           returningResponse:&urlResponse
                                                       error:&connectionError];
    
    if (connectionError)
        return [ResourceBase responseFromError:connectionError];
    
    NSError *jsonDeserializationError = nil;
    NSDictionary *resultsDictionary = [NSJSONSerialization JSONObjectWithData:receivedData
                                                               options:kNilOptions
                                                                 error:&jsonDeserializationError];
    
    if (jsonDeserializationError)
        return [ResourceBase responseFromError:jsonDeserializationError];
    
    NSNumber *successValue = resultsDictionary[kResultSuccessKey];
    BOOL success = [successValue boolValue];
    NSArray *data = [resultsDictionary valueForKey:kResultDataKey];
    
    return [[Response alloc] initWithSuccess:success AndData:data];
}

#pragma mark - Helper methods

+(Response*)responseFromError:(NSError*)error
{
    NSString* errorDescription = [error description]; // TODO: Verify that description returns something meaningful
    return [ResourceBase responseFromErrorMessage: errorDescription];
}

+(Response*)responseFromErrorMessage:(NSString*)errorMessage
{
    NSLog(@"%@", errorMessage);
    Response *response = [[Response alloc] initWithSuccess:NO AndData:@[errorMessage]];
    return response;
}

@end
