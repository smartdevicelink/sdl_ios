//
//  SDLLockedMapTable.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SDLLockedMapTable<KeyType, ObjectType> : NSObject

#pragma mark - Initializers
- (instancetype)init NS_UNAVAILABLE;

/// Create a new locked mutable dictionary with a given dispatch queue. All calls will be reader/writer locked on the queue so that only one operation will occur at a time.
///
/// @param keyOptions A bit field that specifies the options for the keys in the map table. For possible values, see NSMapTableOptions.
/// @param valueOptions A bit field that specifies the options for the values in the map table. For possible values, see NSMapTableOptions.
/// @param queue The queue to use. It can be either a serial or concurrent queue.
- (instancetype)initWithKeyOptions:(NSPointerFunctionsOptions)keyOptions valueOptions:(NSPointerFunctionsOptions)valueOptions queue:(dispatch_queue_t)queue;

#pragma mark - Removing
- (void)removeAllObjects;
- (void)removeObjectForKey:(nullable KeyType)aKey;

#pragma mark - Getting / Setting
- (nullable ObjectType)objectForKey:(nullable KeyType)aKey;
- (void)setObject:(nullable ObjectType)anObject forKey:(nullable KeyType)aKey;

#pragma mark Retrieving Information

/// The number of objects in the dictionary.
///
/// This will occur synchronously and will not return until the operation completes.
/// @return The number of objects in the dictionary.
- (NSUInteger)count;

- (NSDictionary<KeyType, ObjectType> *)dictionaryRepresentation;

#pragma mark Subscripting
- (void)setObject:(nullable ObjectType)object forKeyedSubscript:(KeyType<NSCopying>)key;
- (nullable ObjectType)objectForKeyedSubscript:(KeyType<NSCopying>)key;

@end

NS_ASSUME_NONNULL_END
