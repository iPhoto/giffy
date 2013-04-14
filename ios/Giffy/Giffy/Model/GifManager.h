//
//  GifManager.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GifManager;

@protocol GifManagerDelegate <NSObject>

@required
-(void)gifManager:(GifManager *)manager didFinishCreatingGif:(UIImage *)gif withThumbnail:(UIImage *)thumbnail;

@optional
-(void)gifManager:(GifManager *)manager didFinishUploadingImageIndex:(int)imageIndex of:(int)imageCount;
-(void)gifManager:(GifManager *)manager didReceiveError:(NSString*)errorMessage;

@end

@interface GifManager : NSObject

-(id)initWithDelegate:(id<GifManagerDelegate>)delegate;

-(void)addImage:(UIImage *)image;
-(void)addName:(NSString *)name description:(NSString *)description;
-(void)finish;

@property (readonly, nonatomic) id<GifManagerDelegate> delegate;
@property (readonly, atomic) UIImage* gif;
@property (readonly, atomic) UIImage* thumbnail;

@end
