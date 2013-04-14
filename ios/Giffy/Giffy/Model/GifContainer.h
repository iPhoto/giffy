//
//  GifContainer.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface GifContainer : Model

@property (strong, nonatomic) NSData *gif;
@property (strong, nonatomic) NSString *gifDescription;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSData *thumbnail;

@end
