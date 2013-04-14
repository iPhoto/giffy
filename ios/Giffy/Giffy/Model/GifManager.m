//
//  GifManager.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifManager.h"
#import "GifResouce.h"
#import "NSMutableArray_ThreadSafeQueueAdditions.h"

@interface GifManager()

@property (atomic) int addedImageCount;
@property (strong, atomic) BuilderId* builderId;
@property (strong, atomic) ContainerId * containerId;
@property (readwrite, strong, atomic) UIImage* gif;
@property (readonly, strong, nonatomic) GifResouce* gifResource;
@property (readwrite, nonatomic) BOOL isComplete;
@property (readwrite, strong, atomic) UIImage* preview;
@property (readwrite, strong, atomic) UIImage* thumbnail;
@property (readwrite, atomic) BOOL updateRequired;

@property (atomic) BOOL isFinishWaitingToBeQueued;
@property (atomic) BOOL isUpdateWaitingToBeQueued;
@property (strong, nonatomic) NSMutableArray *imageUploadQueue; // Array of GifComponent
@property (readonly, strong, nonatomic) dispatch_queue_t workQueue;

@end

// TODO: Add logic to detect when the container got thrown away on the server and therefore all images need to be re-sent.
@implementation GifManager

-(id)initWithDelegate:(id<GifManagerDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        _gifResource = [[GifResouce alloc] init];
        _imageUploadQueue = [[NSMutableArray alloc] init];
        _workQueue = dispatch_queue_create("GifManager dispatch", NULL);
        
        [self queueStart];
    }
    
    return self;
}

-(id)initWithGifContainer:(GifContainer *)container
{
    self = [super init];
    if(self)
    {
        _gifResource = [[GifResouce alloc] init];
        _workQueue = dispatch_queue_create("GifManager dispatch", NULL);
        
        [self initializeFromGifContainer:container];
        _updateRequired = NO;
    }
    
    return self;
}

#pragma mark - Property implementations

@synthesize gifDescription = _gifDescription;

-(NSString*) gifDescription
{
    return _gifDescription;
}

-(void)setGifDescription:(NSString *)gifDescription
{
    @synchronized(self)
    {
        _gifDescription = gifDescription;
        self.updateRequired = YES;
    }
}

-(void)setIsComplete:(BOOL)isComplete
{
    _isComplete = isComplete;
    self.imageUploadQueue = nil;
}

@synthesize name = _name;

-(NSString*) name
{
    return _name;
}

-(void)setName:(NSString *)name
{
    @synchronized(self)
    {
        _name = name;
        self.updateRequired = YES;
    }
}

#pragma mark - Public methods

-(void)addImage:(UIImage *)image
{
    NSAssert(image, @"No image was specified to addImage:");
    NSAssert(self.imageUploadQueue, @"This GifManager is already complete.");
    
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    GifComponent *component = [[GifComponent alloc] init];
    component.imageData = data;
    component.order = self.addedImageCount++;
    
    [self.imageUploadQueue enqueue:component];
    
    [self queueAddImageIfPossible];
}

-(void)finish
{
    if (self.containerId || self.isComplete)
    {
        NSLog(@"Error: the GifManager was finished multiple times");
        return;
    }
    
    self.isFinishWaitingToBeQueued = YES;
    [self queueFinishIfPossible];
}

-(void)update
{
    self.isUpdateWaitingToBeQueued = YES;
    [self queueUpdateIfPossible];
}

#pragma mark - Helper methods

-(void)addImageAsync
{
    if (![self verifyBuilder])
        return;
    
    GifComponent *component = [self.imageUploadQueue dequeue];
    component.builderId = self.builderId;
    
    if (![self.gifResource add:component])
    {
        [self notifyError:@"Error sending an image to the server."];
        return;
    }
    
    [self notifyUpdloadedImage:component.order];
    
    [self queueFinishIfPossible];
}

-(void)finishAync
{
    if (![self verifyBuilder])
        return;
    
    if (self.addedImageCount == 0)
    {
        [self notifyError:@"No images have been added to the GIF file."];
        return;
    }
    
    GifContainer* container = [self.gifResource finish:self.builderId];
    if (!container)
    {
        [self notifyError:@"Error finalizing the GIF file on the server."];
        return;
    }
    
    [self initializeFromGifContainer:container];
    [self notifyFinished];
    
    // Update may have been called, so now that we are done creating the GIF, we can safely update.
    [self queueUpdateIfPossible];
}

-(void)initializeFromGifContainer:(GifContainer *)container
{
    self.containerId = [[ContainerId alloc] initWithId:container.idValue];
    
    if (container.thumbnail)
        self.thumbnail = [UIImage imageWithData:container.thumbnail];
    
    if (container.preview)
        self.preview = [UIImage imageWithData:container.preview];
    
    if (container.gif)
        self.gif = [UIImage imageWithData:container.gif];
    
    // If the name was already set by the user, don't overwrite it with the initial value from the server.
    if (!self.name && container.name)
        self.name = container.name;
    
    // If the description was already set by the user, don't overwrite it with the initial value from the server.
    if (!self.gifDescription && container.gifDescription)
        self.gifDescription = container.gifDescription;
    
    self.isComplete = YES;
}

-(void)notifyError:(NSString*)errorMessage
{
    NSLog(@"GifManager Error: %@", errorMessage);
    if (self.delegate &&[self.delegate respondsToSelector:@selector(gifManager:didReceiveError:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate gifManager:self didReceiveError:errorMessage];
        });
    }
}

-(void)notifyFinished
{
    if (self.delegate)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate gifManagerDidFinishCreatingGif:self];
        });
    }
}

-(void)notifyUpdateComplete
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(gifManagerDidFinishUpdating:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate gifManagerDidFinishUpdating:self];
        });
    }
}

-(void)notifyUpdloadedImage:(int)imageIndex
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(gifManager:didFinishUploadingImageIndex:of:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate gifManager:self didFinishUploadingImageIndex:imageIndex of:self.addedImageCount];
        });
    }
}

-(BOOL)queueAddImageIfPossible
{
    if ([self.imageUploadQueue count] != 0)
    {
        NSLog(@"Adding addImageAsync to the work queue.");
        dispatch_async(self.workQueue, ^{ [self addImageAsync]; });
        return YES;
    }
    
    return NO;
}

-(BOOL)queueFinishIfPossible
{
    if (self.isFinishWaitingToBeQueued && [self.imageUploadQueue count] == 0)
    {
        NSLog(@"Adding finishAync to the work queue.");
        dispatch_async(self.workQueue, ^{ [self finishAync]; });
        self.isFinishWaitingToBeQueued = NO;
        return YES;
    }
    
    return NO;
}

-(BOOL)queueStart
{
    NSLog(@"Adding startAsync to the work queue.");
    dispatch_async(self.workQueue, ^{ [self startAsync]; });
    return YES;
}

-(BOOL)queueUpdateIfPossible
{
    if (self.isUpdateWaitingToBeQueued && self.containerId)
    {
        NSLog(@"Adding updateAsync to the work queue.");
        dispatch_async(self.workQueue, ^{ [self updateAsync]; });
        self.isUpdateWaitingToBeQueued = NO;
        return YES;
    }
    
    return NO;
}

-(void)startAsync
{
    self.builderId = [self.gifResource start];
}

-(void)updateAsync
{    
    if (self.updateRequired)
    {
        if (![self verifyBuilder])
            return;
        
        if (!self.containerId)
        {
            [self notifyError:@"Cannot add a name and description before the gif has been completed."];
            return;
        }
        
        if (![self.gifResource addName:self.name description:self.gifDescription toContainer:self.containerId])
        {
            [self notifyError:@"Error sending the name and description to the server."];
            return;
        }
    }
    
    [self notifyUpdateComplete];
}

-(BOOL)verifyBuilder
{
    if (!self.builderId)
        self.builderId = [self.gifResource start];
    
    if (self.builderId)
        return YES;
    
    [self notifyError:@"Error connecting to the server."];
    return NO;
}

@end
