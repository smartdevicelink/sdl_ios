//
//  SDLMutableDataQueue.h
//  
//
//  Created by David Switzer on 3/2/17.
//
//

#import <Foundation/Foundation.h>

@interface SDLMutableDataQueue : NSObject

- (instancetype)init;

// front returns the NSMutableData * buffer at the front of the queue,
// but does not remove it -- modeled after the STL C++ queue front method
- (NSMutableData *)front;

// pop removes the buffer at the head of the queue -- modeled after the
// STL C++ queue pop method
- (void)pop;

// Enqueues a new NSMutableData * buffer at the back of the queue
- (void)enqueue:(NSMutableData *)data;

// Empty the queue
- (void)flush;

@property(nonatomic, assign, readonly) NSUInteger count;

// Since data can be dequeued from the front multiple times, use this
// flag to track whether it has been dequeued once
@property(nonatomic, assign, readonly) BOOL frontDequeued;

@end
