//
//  ContainerId.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "ContainerId.h"

@implementation ContainerId

-(id)initWithId:(long)idValue
{
    self = [super init];
    if (self)
        _idValue = idValue;
    
    return  self;
}

@end
