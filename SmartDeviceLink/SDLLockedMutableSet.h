//
//  SDLLockedMutableSet.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockedMutableSet<ObjectType> : NSObject

/// Create a new locked mutable array with a given dispatch queue. All calls will be reader/writer locked on the queue so that only one operation will occur at a time.
///
/// @param queue The queue to use. It can be either a serial or concurrent queue.
- (instancetype)initWithQueue:(dispatch_queue_t)queue;

#pragma mark - Getting / Setting

#pragma mark Retrieving information

/// The number of objects in the array.
///
/// This will occur synchronously and will not return until the operation completes.
/// @return The number of objects in the array
- (NSUInteger)count;

#pragma mark Adding Objects
/// Inserts a given object at the end of the array.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param object The object to add to the end of the array’s content. This value must not be nil.
- (void)addObject:(ObjectType)object;

#pragma mark Subscripting
- (void)setObject:(ObjectType)object atIndexedSubscript:(NSUInteger)idx;
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
