//
//  GifManager.m
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import "GifManager.h"
#import "GifResouce.h"

@interface GifManager()

@property (strong, atomic) BuilderId* builderId;
@property (strong, atomic) ContainerId * containerId;
@property (readwrite, atomic) UIImage* gif;
@property (readonly, strong, nonatomic) GifResouce* gifResource;
@property (atomic) int sentImageCount;
@property (readwrite, atomic) UIImage* thumbnail;


@end

@implementation GifManager

-(id)initWithDelegate:(id<GifManagerDelegate>)delegate
{
    self = [super init];
    if(self)
    {
        _delegate = delegate;
        _gifResource = [[GifResouce alloc] init];
        
        // TODO: dispatch this to a background thread.
        self.builderId = [self.gifResource start];
    }
    
    return self;
}

-(void)addImage:(UIImage *)image
{
    if (![self verifyBuilder])
        return;
    
    // TODO: Cache the image and send it later
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    
    GifComponent *component = [[GifComponent alloc] init];
    component.builderId = self.builderId;
    component.imageData = data;
    component.order = self.sentImageCount++;
    
    if (![self.gifResource add:component])
        [self reportError:@"Error sending an image to the server."];
}

-(void)addName:(NSString *)name description:(NSString *)description
{
    if (![self verifyBuilder])
        return;
    
    // TODO: Cache these and send them later and only after the gif has finished being created.
    if (!self.containerId)
        [self reportError:@"Cannot add a name and description before the gif has been completed."];
    
    if (![self.gifResource addName:name description:description toContainer:self.containerId])
        [self reportError:@"Error sending the name and description to the server."];
}

-(void)finish
{
    if (![self verifyBuilder])
        return;
    
    // TODO: Do this after all queued images have been sent
    if (self.sentImageCount == 0)
        [self reportError:@"No images have been added to the GIF file."];
    
    GifContainer* container = [self.gifResource finish:self.builderId];
    if (!container)
        [self reportError:@"Error finalizing the GIF file on the server."];
    
    self.containerId = [[ContainerId alloc] initWithId:container.idValue];
    self.thumbnail = [UIImage imageWithData:container.thumbnail];
    self.gif = [UIImage imageWithData:container.gif];
}

#pragma mark - Helper methods

-(void)reportError:(NSString*)errorMessage
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(gifManager:didReceiveError:)])
        [self.delegate gifManager:self didReceiveError:errorMessage];
}

-(BOOL)verifyBuilder
{
    if (!self.builderId)
        self.builderId = [self.gifResource start];
    
    if (self.builderId)
        return YES;
    
    [self reportError:@"Error connecting to the server."];
    return NO;
}

@end
