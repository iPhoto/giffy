//
//  GifResouce.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifResouce.h"

@implementation GifResouce

-(BOOL)add:(GifComponent*)component
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                type:RequestTypePost
                                              action:kGifController_Add_Action
                                                  values:@{kGifComponent_Image_Key : component.imageData, kGifComponent_Order_Key: @(component.order)}];
    
    if (!response.success)
    {
        NSLog(@"gif/add was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce boolFromResponse:response];
}

-(BOOL)addName:(NSString*)name description:(NSString*) description
{
    Response* response = [self makeRequestFromController:kGifController_Name
                                                    type:RequestTypePost
                                                  action:kGifController_AddDescription_Action
                                                  values:@{kGifContainer_Name_Key : name, kGifContainer_Description_Key: description}];
    
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
                                                  values:@{kGifController_BuilderId_Parameter : builderId.idValue}];
    
    if (!response.success)
    {
        NSLog(@"gif/finish was not successful: %@", response.message);
        return NO;
    }
    
    return [GifResouce gifContainerFromResponse:response];
}

//-(NSArray*)get; // Returns an array of GifContainer
//-(GifContainer*)get:(BuilderId*)builderId;
//-(BuilderId*)start;

@end
