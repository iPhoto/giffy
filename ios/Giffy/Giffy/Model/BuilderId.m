//
//  BuilderId.m
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "BuilderId.h"

@implementation BuilderId

-(id)initWithId:(int)idValue
{
    self = [super init];
    if (self)
        _idValue = idValue;
    
    return  self;
}

@end
