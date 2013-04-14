//
//  Base64.h
//  Giffy
//
//  Created by Michael Dour on 4/13/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString*)base64forData:(NSData*)theData;
+(NSData*)dataForBase64:(NSString*)base64;

@end
