//
//  ContainerId.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContainerId : NSObject

@property (readonly, nonatomic) long idValue;

-(id)initWithId:(long)idValue;

@end
