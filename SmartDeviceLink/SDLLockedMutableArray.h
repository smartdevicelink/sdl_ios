//
//  SDLLockedMutableArray.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockedMutableArray<ObjectType> : NSObject

#pragma mark - Initializers
- (instancetype)init NS_UNAVAILABLE;

/// Create a new locked mutable array with a given dispatch queue. All calls will be reader/writer locked on the queue so that only one operation will occur at a time.
///
/// @param queue The queue to use. It can be either a serial or concurrent queue.
- (instancetype)initWithQueue:(dispatch_queue_t)queue;

#pragma mark - Removing
/// Empties the array of its entries.
///
/// This will occur asynchronously and may return before the operation completes.
- (void)removeAllObjects;

/// Removes the object at `index`.
///
/// To fill the gap, all elements beyond index are moved by subtracting 1 from their index.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param index The index from which to remove the object in the array. The value must not exceed the bounds of the array.
- (void)removeObjectAtIndex:(NSUInteger)index;

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

/// Inserts a given object into the array’s contents at a given index.
///
/// If index is already occupied, the objects at index and beyond are shifted by adding 1 to their indices to make room.
/// Note that NSArray objects are not like C arrays. That is, even though you specify a size when you create an array, the specified size is regarded as a “hint”; the actual size of the array is still 0. This means that you cannot insert an object at an index greater than the current count of an array. For example, if an array contains two objects, its size is 2, so you can add objects at indices 0, 1, or 2. Index 3 is illegal and out of bounds; if you try to add an object at index 3 (when the size of the array is 2), NSMutableArray raises an exception.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param anObject The object to add to the array's content. This value must not be nil.
/// @param index The index in the array at which to insert anObject. This value must not be greater than the count of elements in the array.
- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

#pragma mark Subscripting
- (void)setObject:(__kindof ObjectType)object atIndexedSubscript:(NSUInteger)idx;
- (__kindof ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
