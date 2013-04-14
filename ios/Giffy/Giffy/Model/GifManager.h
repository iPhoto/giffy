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
-(void)gifManagerDidFinishCreatingGif:(GifManager *)manager;

@optional
-(void)gifManager:(GifManager *)manager didFinishUploadingImageIndex:(int)imageIndex of:(int)imageCount;
-(void)gifManager:(GifManager *)manager didReceiveError:(NSString*)errorMessage;
-(void)gifManagerDidFinishUpdating:(GifManager *)manager;

@end

@interface GifManager : NSObject

-(id)initWithDelegate:(id<GifManagerDelegate>)delegate;

-(void)addImage:(UIImage *)image;
-(void)finish;
-(void)update;

@property (readonly, nonatomic) id<GifManagerDelegate> delegate;
@property (atomic) NSString* description;
@property (readonly, atomic) UIImage* gif;
@property (atomic) NSString* name;
@property (readonly, atomic) UIImage* preview;
@property (readonly, atomic) UIImage* thumbnail;

@end
