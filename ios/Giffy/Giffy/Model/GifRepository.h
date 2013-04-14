//
//  GifRepository.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContainerId.h"
#import "GifManager.h"

@interface GifRepository : NSObject

-(GifManager*)getGifManagerWithContainerId:(ContainerId *)containerId;
-(GifManager*)getGifManagerWithContainerIdValue:(long)containerIdValue;
-(NSArray*)getCompletedGifManagers; // Array of GifManager

@end
