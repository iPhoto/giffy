//
//  ResourceBase.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "ResourceBase.h"
#import "GiffyAppDelegate.h"
#import "Authentication.h"

#define kBaseUrl @"http://giffy.azurewebsites.net/api/" // TODO Move to config file

#define kResultDataKey @"Data"
#define kResultMessageKey @"Message"
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

-(Response*)makeRequestFromController:(NSString *)controller type:(RequestType)requestType values:(NSDictionary *)values
{
    return [self makeRequestFromController:controller type:requestType action:nil values:values];
}

-(Response*)makeRequestFromController:(NSString *)controller type:(RequestType)requestType action:(NSString *)action values:(NSDictionary *)values
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, controller];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request addValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    
    if(![controller isEqualToString:kLoginController_Name])
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
    id data = [resultsDictionary valueForKey:kResultDataKey];
    NSString* message = [resultsDictionary valueForKey:kResultMessageKey];
    
    if(!success)
    {
        NSAssert(message, @"There was no error message from the server.");
        return [[Response alloc] initWithMessage:message];
    }
    
    return [[Response alloc] initWithSuccess:success data:data];
}

#pragma mark - Serialization Methods

+(Authentication*)authenticationFromResponse:(Response*)response
{
    if(![response.data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Unexpected data object type.");
        return nil;
    }
    
    id data = (NSDictionary*)response.data;
    
    NSDictionary* dataDictionary = (NSDictionary*)data;
    
    NSString* userName = dataDictionary[kAuthentication_UserName_Key];
    NSString* token = dataDictionary[kAuthentication_Token_Key];
    
    return [[Authentication alloc] initWithToken:token userName:userName];
}

+(BOOL)boolFromResponse:(Response*)response
{
    if(![response.data isKindOfClass:[NSNumber class]])
    {
        NSLog(@"Unexpected data object type.");
        return NO;
    }
    
    NSNumber *boolNumber = (NSNumber*)response.data;
    return [boolNumber boolValue];
}

+(GifContainer*)gifContainerFromResponse:(Response*)response
{
    if(![response.data isKindOfClass:[NSArray class]])
    {
        NSLog(@"Unexpected data object type.");
        return nil;
    }
    
    NSArray *dataArray = (NSArray*)response.data;
    
    NSUInteger count = [dataArray count];
    NSAssert(count == 1, @"The gif container response should have one data result.");
    
    if (count == 0)
    {
        NSLog(@"No login data returned");
        return nil;
    }
    
    id data = dataArray[0];
    if (![data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"The gif container response data is not in the correct format.");
        return nil;
    }
    
    NSDictionary* dataDictionary = (NSDictionary*)data;
    
    GifContainer* container = [[GifContainer alloc] init];
    container.gif = dataDictionary[kGifContainer_Gif_Key];
    container.gifDescription = dataDictionary[kGifContainer_Description_Key];
    container.name = dataDictionary[kGifContainer_Name_Key];
    container.thumbnail = dataDictionary[kGifContainer_Thumbnail_Key];
    return container;
}

+(NSDictionary*)jsonDictionaryFromGifComponent:(GifComponent*)component
{
    return @{kGifComponent_Image_Key : component.imageData,
             kGifComponent_Order_Key : @(component.order)};
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
    Response *response = [[Response alloc] initWithMessage:errorMessage];
    return response;
}

@end
