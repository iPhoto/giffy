//
//  GifRepository.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifContainer.h"
#import "GifRepository.h"
#import "GifResouce.h"

@interface GifRepository()

@property (readonly, strong, nonatomic) GifResouce* gifResource;

@end

@implementation GifRepository

-(id)init
{
    self = [super init];
    if (self)
    {
        _gifResource = [[GifResouce alloc] init];
    }
    
    return self;
}

-(GifManager*)getGifManagerWithContainerId:(ContainerId *)containerId
{
    GifContainer *container = [self.gifResource get:containerId];
    if (!container)
        return nil;
    
    return [[GifManager alloc] initWithGifContainer:container];
}

-(GifManager*)getGifManagerWithContainerIdValue:(long)containerIdValue
{
    return [self getGifManagerWithContainerId:[[ContainerId alloc] initWithId:containerIdValue]];
}

-(NSArray*)getCompletedGifManagers
{
    NSArray *containers = [self.gifResource get];
    if (!containers)
        return nil;
    
    NSMutableArray *result = [[NSMutableArray alloc] initWithCapacity:[containers count]];
    for (GifContainer *container in containers)
        [result addObject:[[GifManager alloc] initWithGifContainer:container]];
    
    return [result copy];
}

@end
