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

-(id)initWithSuccess:(BOOL)success AndData:(NSArray *)data
{
    self = [super init];
    if(self)
    {
        _data = data;
        _success = success;
    }
    
    return self;
}

-(NSString*)errorMessage
{
    if(self.success)
        return nil;
    
    return self.data[0];
}

@end
