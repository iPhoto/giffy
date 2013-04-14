//
//  GifResouce.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "ResourceBase.h"
#import "BuilderId.h"
#import "ContainerId.h"

@interface GifResouce : ResourceBase

-(BOOL)add:(GifComponent *)component;
-(BOOL)addName:(NSString *)name description:(NSString *) description toContainer:(ContainerId *)containerId;
-(GifContainer *)finish:(BuilderId *)builderId;
-(NSArray *)get; // Returns an array of GifContainer
-(GifContainer*)get:(ContainerId *)containerId;
-(GifBuilder *)start;

@end
