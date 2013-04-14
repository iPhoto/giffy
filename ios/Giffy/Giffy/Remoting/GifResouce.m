//
//  GifResouce.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifResouce.h"
#import "Base64.h"

@implementation GifResouce


-(BOOL)add:(GifComponent*)component
{
    NSDictionary *values = @{kGifComponent_BuilderId_Key : @(component.builderId.idValue),
                             kGifComponent_Image_Key : [Base64 base64forData:component.imageData],
                             kGifComponent_Order_Key: @(component.order)};
    
    Response* response = [self makeRequestFromController:kGifController_Name
                                                type:RequestTypePost
                                              action:kGifController_Add_Action
                                                  values:values];
    
    if (!response.success)
    {
        NSLog(@"gif/add was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce boolFromResponse:response];
}

-(BOOL)addName:(NSString*)name description:(NSString*) description toContainer:(ContainerId *)containerId
{
    NSDictionary *values = @{kGifController_GifContainerID_Key : @(containerId.idValue),
                             kGifContainer_Name_Key : name,
                             kGifContainer_Description_Key: description};
    
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypePost
                                                  action:kGifController_AddDescription_Action
                                                  values:values];
    
    if (!response.success)
    {
        NSLog(@"gif/addDescription was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce boolFromResponse:response];
}

-(GifContainer*)finish:(BuilderId*)builderId
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypePost
                                                  action:kGifController_Finish_Action
                                                  values:@{kGifController_BuilderId_Parameter : @(builderId.idValue)}];
    
    if (!response.success)
    {
        NSLog(@"gif/finish was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce gifContainerFromResponse:response];
}

-(NSArray*)get
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypeGet
                                                  values:nil];
    
    if (!response.success)
    {
        NSLog(@"gif/get was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce arrayOfGifContainersFromResponse:response];
}

-(GifContainer*)get:(ContainerId *)containerId
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypeGet
                                                  values:@{kGifController_Id_Parameter : @(containerId.idValue)}];
    
    if (!response.success)
    {
        NSLog(@"gif/get was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce gifContainerFromResponse:response];
}

-(BuilderId*)start
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypePost
                                                  action:kGifController_Start_Action
                                                  values:nil];
    
    if (!response.success)
    {
        NSLog(@"gif/start was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce builderIdFromResponse:response];
}

@end
