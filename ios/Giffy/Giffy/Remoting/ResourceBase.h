//
//  ResourceBase.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

#define kLoginControllerName @"login"

#define kLoginResponseUserNameKey @"UserName"
#define kLoginResponseTokenKey @"Token"

#define kLoginRequestUserNameKey @"UserName"
#define kLoginRequestTokenKey @"AuthenticationToken"


typedef CF_ENUM(int, RequestType) {
    RequestTypeGet = 1,
    RequestTypePost = 2,
    RequestTypePut = 3,
    RequestTypeDelete = 4
};

@interface ResourceBase : NSObject

// Dictionary (key value pairs) (either query string parameter or JSON post data)
-(Response*)makeRequestFromController:(NSString*)controller
                             WithType:(RequestType)requestType
                           WithAction:(NSString*)action
                            AndValues:(NSDictionary*) values;

-(Response*)makeRequestFromController:(NSString*)controller
                             WithType:(RequestType)requestType
                            AndValues:(NSDictionary*) values;

@end
