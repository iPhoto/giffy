//
//  ResourceBase.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Authentication.h"
#import "BuilderId.h"
#import "GifComponent.h"
#import "GifContainer.h"
#import "Response.h"

#define kGifController_Name @"gif"
#define kGifController_Add_Action @"add"
#define kGifController_AddDescription_Action @"addDescription"
#define kGifController_Finish_Action @"finish"
#define kGifController_Start_Action @"start"

#define kGifController_Id_Parameter @"id"
#define kGifController_BuilderId_Parameter @"builderID"

#define kLoginController_Name @"login"

#define kAuthentication_UserName_Key @"UserName"
#define kAuthentication_Token_Key @"Token"

#define kGifComponent_BuilderId_Key @"BuilderId"
#define kGifComponent_Image_Key @"Image"
#define kGifComponent_Order_Key @"Order"

#define kGifContainer_Description_Key @"Description"
#define kGifContainer_Gif_Key @"Gif"
#define kGifController_GifContainerID_Key @"GifContainerID"
#define kGifContainer_Name_Key @"Name"
#define kGifContainer_Thumbnail_Key @"Thumbnail"

#define kModel_ID_Key @"ID"

#define kUserCredentials_Password_Key @"Password"
#define kUserCredentials_UserName_Key @"UserName"

#define kLoginRequestUserNameKey @"UserName"
#define kLoginRequestAuthenticationTokenKey @"AuthenticationToken"


typedef CF_ENUM(int, RequestType) {
    RequestTypeGet = 1,
    RequestTypePost = 2,
    RequestTypePut = 3,
    RequestTypeDelete = 4
};

@interface ResourceBase : NSObject

-(Response*)makeRequestFromController:(NSString*)controller
                                 type:(RequestType)requestType
                               values:(NSDictionary*) values;

// Dictionary (key value pairs) (either query string parameter or JSON post data)
-(Response*)makeRequestFromController:(NSString*)controller
                                 type:(RequestType)requestType
                               action:(NSString*)action
                               values:(NSDictionary*) values;


+(NSArray*)arrayOfGifContainersFromResponse:(Response*)response;
+(Authentication*)authenticationFromResponse:(Response*)response;
+(BOOL)boolFromResponse:(Response*)response;
+(BuilderId*)builderIdFromResponse:(Response*)response;
+(GifContainer*)gifContainerFromResponse:(Response*)response;
+(NSDictionary*)jsonDictionaryFromGifComponent:(GifComponent*)component;

@end
