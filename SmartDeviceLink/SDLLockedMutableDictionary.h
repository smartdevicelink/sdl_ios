//
//  SDLLockedDictionary.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockedMutableDictionary<KeyType, ObjectType> : NSObject

#pragma mark - Initializers
- (instancetype)init NS_UNAVAILABLE;

/// Create a new locked mutable dictionary with a given dispatch queue. All calls will be reader/writer locked on the queue so that only one operation will occur at a time.
/// If the 
/// @param queue The queue to use. It can be either a serial or concurrent queue.
- (instancetype)initWithQueue:(dispatch_queue_t)queue;


#pragma mark - Removing

/// Removes a given key and its associated value from the dictionary.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param key The key to search for and remove the associated object. Does nothing if key does not exist.
- (void)removeObjectForKey:(KeyType<NSCopying>)key;

/// Empties the dictionary of its entries.
///
/// This will occur asynchronously and will return before the operation completes.
- (void)removeAllObjects;


#pragma mark - Getting / Setting

/// Returns the value associated with a given key.
///
/// This will occur synchronously and will not return until the operation completes.
/// @param key The key for which to return the corresponding value.
/// @return The value associated with aKey, or nil if no value is associated with aKey.
- (ObjectType)objectForKey:(KeyType<NSCopying>)key;

/// Adds a given key-value pair to the dictionary.
///
/// This will occur asynchronously and may return before the operation completes.
/// @param object The value for aKey. A strong reference to the object is maintained by the dictionary.
/// @param key The key for value. The key is copied (using copyWithZone:; keys must conform to the NSCopying protocol). If aKey already exists in the dictionary, anObject takes its place.
- (void)setObject:(ObjectType)object forKey:(KeyType<NSCopying>)key;

#pragma mark Subscripting
- (void)setObject:(ObjectType)object atIndexedSubscript:(KeyType<NSCopying>)key;
- (ObjectType)objectAtIndexedSubscript:(KeyType<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
