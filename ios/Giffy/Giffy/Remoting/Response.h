//
//  Response.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Response : NSObject

@property (readonly, strong, nonatomic) NSArray* data;
@property (readonly, nonatomic) BOOL success;

-(id)initWithSuccess:(BOOL)success AndData:(NSArray*)data;
-(NSString*)errorMessage;

@end
