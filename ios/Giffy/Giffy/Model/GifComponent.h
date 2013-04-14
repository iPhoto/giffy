//
//  GifComponent.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuilderId.h"
#import "Model.h"

@interface GifComponent : Model

@property (nonatomic) BuilderId* builderId;
@property (strong, nonatomic) NSData* imageData;
@property (nonatomic) NSUInteger order;

@end
