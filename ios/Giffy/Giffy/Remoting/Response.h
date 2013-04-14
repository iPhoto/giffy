//
//  Response.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (readonly, strong, nonatomic) id data;
@property (readonly, nonatomic) NSString* message;
@property (readonly, nonatomic) BOOL success;

-(id)initWithMessage:(NSString*)message;
-(id)initWithSuccess:(BOOL)success data:(id)data;

@end
