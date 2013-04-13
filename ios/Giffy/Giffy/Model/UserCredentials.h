//
//  UserCredentials.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserCredentials : NSObject

-(id)initWithUserName:(NSString*)userName AndPassword:(NSString*)password;

@property (strong, nonatomic) NSString* authenticationToken;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* userName;

@end
