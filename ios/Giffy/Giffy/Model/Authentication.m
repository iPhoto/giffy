//
//  Authentication.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "Authentication.h"

@implementation Authentication

-(id)initWithToken:(NSString*)token userName:(NSString*)userName
{
    self = [super init];
    if(self)
    {
        _token = token;
        _userName = userName;
    }
    
    return self;
}

@end
