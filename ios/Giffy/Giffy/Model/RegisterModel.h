//
//  RegisterModel.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject

@property (strong, nonatomic) NSString* confirmPassword;
@property (strong, nonatomic) NSString* password;
@property (strong, nonatomic) NSString* userName;

-(id)initWithUserName:(NSString*)userName AndPassword:(NSString*)password AndConfimation:(NSString*)confirm;

@end
