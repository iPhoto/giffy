//
//  GifManager.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GifContainer.h"
#import "UIImage+animatedGIF.h"

@class GifManager;

@protocol GifManagerDelegate <NSObject>

@optional
-(void)gifManagerDidFinishCreatingGif:(GifManager *)manager;
-(void)gifManager:(GifManager *)manager didFinishUploadingImageIndex:(int)imageIndex of:(int)imageCount;
-(void)gifManager:(GifManager *)manager didReceiveError:(NSString*)errorMessage;
-(void)gifManagerDidFinishUpdating:(GifManager *)manager;

@end

@interface GifManager : NSObject

-(id)initWithDelegate:(id<GifManagerDelegate>)delegate;
-(id)initWithGifContainer:(GifContainer *)container;

-(void)addDelegate:(id<GifManagerDelegate>)delegate;
-(void)removeDelegate:(id<GifManagerDelegate>)delegate;

-(void)addImage:(UIImage *)image;
-(void)finish;
-(void)update;

@property (readonly, atomic) UIImage* gif;
@property (atomic) NSString* gifDescription;
@property (readonly, nonatomic) BOOL isComplete;
@property (atomic) NSString* name;
@property (readonly, atomic) UIImage* preview;
@property (readonly, atomic) UIImage* thumbnail;

@end
