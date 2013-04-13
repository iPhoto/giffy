//
//  UserCredentials.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "UserCredentials.h"

@implementation UserCredentials

-(id)initWithUserName:(NSString*)userName AndPassword:(NSString*)password
{
    self = [self init];
    if(self)
    {
        self.userName = userName;
        self.password = password;
    }
    
    return self;
}

@end
