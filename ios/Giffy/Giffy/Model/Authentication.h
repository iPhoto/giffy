//
//  Authentication.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Response.h"

@interface Authentication : NSObject

@property (readonly, strong, nonatomic) NSString* token;
@property (readonly, strong, nonatomic) NSString* userName;

-(id)initWithToken:(NSString*)token userName:(NSString*)userName;

@end
