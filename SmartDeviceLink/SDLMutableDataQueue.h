//
//  SDLMutableDataQueue.h
//  
//
//  Created by David Switzer on 3/2/17.
//
//

#import <Foundation/Foundation.h>

@interface SDLMutableDataQueue : NSObject

NS_ASSUME_NONNULL_BEGIN

// frontBuffer returns the NSMutableData * buffer at the front of the queue,
// but does not remove it -- modeled after the STL C++ queue front method
- (NSMutableData *)frontBuffer;

// popBuffer removes the buffer at the head of the queue -- modeled after the
// STL C++ queue pop method
- (void)popBuffer;

// Enqueues a new NSMutableData * buffer at the back of the queue
- (void)enqueueBuffer:(NSMutableData *)data;

// Empty the queue
- (void)flush;

@property(nonatomic, assign, readonly) NSUInteger count;

// Since data can be dequeued from the front multiple times, use this
// flag to track whether it has been dequeued once
@property(nonatomic, assign, readonly, getter=isFrontBufferDequeued) BOOL frontDequeued;

NS_ASSUME_NONNULL_END


@end
