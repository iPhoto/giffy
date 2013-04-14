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
#import "Base64.h"
#import "BuilderId.h"

#define kBaseUrl @"http://giffy.azurewebsites.net/api/" // TODO Move to config file

#define kResultDataKey @"Data"
#define kResultMessageKey @"Message"
#define kResultSuccessKey @"Success"

@interface ResourceBase()

@property (strong, nonatomic) NSSet* urlsUsingQueryString;

@end

@implementation ResourceBase

-(NSSet*)urlsUsingQueryString
{
    if (!_urlsUsingQueryString)
        _urlsUsingQueryString = [[NSSet alloc] initWithArray:@[
                                 [NSString stringWithFormat:@"%@%@/%@", kBaseUrl, kGifController_Name, kGifController_Finish_Action]
                                 ]];
    
    return _urlsUsingQueryString;
}

-(Response*)makeRequestFromController:(NSString *)controller type:(RequestType)requestType values:(NSDictionary *)values
{
    return [self makeRequestFromController:controller type:requestType action:nil values:values];
}

-(Response*)makeRequestFromController:(NSString *)controller type:(RequestType)requestType action:(NSString *)action values:(NSDictionary *)values
{
    NSString* urlString = [NSString stringWithFormat:@"%@%@", kBaseUrl, controller];
    
    if (action)
        urlString = [urlString stringByAppendingFormat:@"/%@", action];
    
    BOOL shouldUseQueryString = [self.urlsUsingQueryString containsObject:urlString];
    if(shouldUseQueryString)
    {
        NSString *queryParameters = @"?";
        
        BOOL didAddFirstParameter = NO;
        for (NSString *key in values)
        {
            if (didAddFirstParameter)
                queryParameters = [queryParameters stringByAppendingString:@"&"];
            
            id value = values[key];
            queryParameters = [queryParameters stringByAppendingFormat:@"%@=%@", key, value]; // TODO: escape strings
            
            didAddFirstParameter = YES;
        }
        
        urlString = [urlString stringByAppendingString:queryParameters];
    }
    
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
    
    if(values && !shouldUseQueryString)
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
    
    if (!success)
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

+(BuilderId*)builderIdFromResponse:(Response*)response
{
    if(![response.data isKindOfClass:[NSNumber class]])
    {
        NSLog(@"Unexpected data object type.");
        return NO;
    }
    
    NSNumber *intNumber = (NSNumber*)response.data;
    return [[BuilderId alloc] initWithId:[intNumber intValue]];
}

+(GifContainer*)gifContainerFromResponse:(Response*)response
{
    if (![response.data isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"Unexpected data object type.");
        return nil;
    }
    
    NSDictionary* dataDictionary = (NSDictionary*)response.data;
    
    GifContainer* container = [[GifContainer alloc] init];
    
    container.gif = [Base64 dataForBase64:dataDictionary[kGifContainer_Gif_Key]];
    container.gifDescription = dataDictionary[kGifContainer_Description_Key];
    container.name = dataDictionary[kGifContainer_Name_Key];
    container.thumbnail = [Base64 dataForBase64:dataDictionary[kGifContainer_Thumbnail_Key]];
    
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
