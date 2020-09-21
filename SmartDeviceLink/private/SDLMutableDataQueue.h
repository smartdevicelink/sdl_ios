//
//  SDLMutableDataQueue.h
//
//
//  Created by David Switzer on 3/2/17.
//
//

#import <Foundation/Foundation.h>

/**
 This queue class is used by the IAP data session to provide safe, async writing of RPC messages to the connected SDL compliant accessory. It uses NSMutableData objects because the NSOutputStream has a variable amount of space available based on iOS and accessory buffering. We want to be able to pop the buffer at the head multiiple times and consume as many bytes as there are available in the stream.
 */

@interface SDLMutableDataQueue : NSObject

NS_ASSUME_NONNULL_BEGIN

/**
 frontBuffer returns the NSMutableData * buffer at the front of the queue, but does not remove it - modeled after the STL C++ queue front method

 @return NSMutableData containing the buffer at the head of the queue or nil if
 the queue is empty
 */
- (NSMutableData *_Nullable)frontBuffer;


/**
 popBuffer removes the buffer at the head of the queue -- modeled after the
 STL C++ queue pop method. Use to remove the buffer once all of the data has
 been consumed or the data is no longer valid/needed.
 */
- (void)popBuffer;

/**
 Enqueues a new buffer at the back of the queue

 @param data NSMutableData containing the buffer to enqueue
 */
- (void)enqueueBuffer:(NSMutableData *)data;

/**
 Empty the queue
 */
- (void)removeAllObjects;

/**
 Gets the number of buffers currently enqueued
 */
@property (nonatomic, assign, readonly) NSUInteger count;

/**
 A flag indicating whether the buffer at the head of the queue has been dequeued at least once.
 */
@property (nonatomic, assign, readonly, getter=isFrontBufferDequeued) BOOL frontDequeued;

NS_ASSUME_NONNULL_END


@end
