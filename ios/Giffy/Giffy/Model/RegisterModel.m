//
//  RegisterModel.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "RegisterModel.h"

@implementation RegisterModel

-(id)initWithUserName:(NSString*)userName AndPassword:(NSString*)password AndConfimation:(NSString*)confirm
{
    self = [self init];
    if(self)
    {
        self.userName = userName;
        self.password = password;
        self.confirmPassword = password;
    }
    
    return self;
}

@end
