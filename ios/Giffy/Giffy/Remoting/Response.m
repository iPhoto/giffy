//
//  Response.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "Response.h"

@interface Response()


@end

@implementation Response

-(id)initWithMessage:(NSString*)message
{
    self = [super init];
    if(self)
    {
        _message = message;
        _success = NO;
    }
    
    return self;
}

-(id)initWithSuccess:(BOOL)success data:(id)data
{
    self = [super init];
    if(self)
    {
        _data = data;
        _success = success;
    }
    
    return self;
}

@end
