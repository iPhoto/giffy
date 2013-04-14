//
//  NSMutableArray_QueueAdditions.h
//  Giffy
//
//  Created by Michael Dour on 4/14/13.
//  Copyright (c) 2013 The Giffy Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (ThreadSafeQueueAdditions)
- (id) dequeue;
- (void) enqueue:(id)obj;
@end

@implementation NSMutableArray (ThreadSafeQueueAdditions)
// Queues are first-in-first-out, so we remove objects from the head
- (id) dequeue {
    @synchronized(self)
    {
        id headObject = [self objectAtIndex:0];
        if (headObject != nil) {
            [self removeObjectAtIndex:0];
        }
        return headObject;
    }
}

// Add to the tail of the queue (no one likes it when people cut in line!)
- (void) enqueue:(id)anObject {
    @synchronized(self)
    {
        [self addObject:anObject];
    }
}
@end
