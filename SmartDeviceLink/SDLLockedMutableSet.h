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

#pragma mark - Removing

/// Empties the set of its entries.
///
/// This will occur asynchronously and may return before the operation completes.
- (void)removeAllObjects;

#pragma mark Retrieving information

/// The number of objects in the set.
///
/// This will occur synchronously and will not return until the operation completes.
/// @return The number of objects in the set
- (NSUInteger)count;

/// Retrieve an immutable set version of this mutable set at the current point.
- (NSSet<ObjectType> *)immutableSet;

#pragma mark Modifications

/// Adds each object in another given set to the receiving set, if not present.
/// @param otherSet The set of objects to add to the receiving set.
- (void)unionSet:(NSSet<ObjectType> *)otherSet;

/// Removes each object in another given set from the receiving set, if present.
/// @param otherSet The set of objects to remove from the receiving set.
- (void)minusSet:(NSSet<ObjectType> *)otherSet;

#pragma mark Adding Objects

/// Inserts a given object into the set.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param object The object to add to set. This value must not be nil.
- (void)addObject:(ObjectType)object;

@end

NS_ASSUME_NONNULL_END
