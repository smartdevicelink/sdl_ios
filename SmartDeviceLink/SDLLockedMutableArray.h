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

- (instancetype)initWithSerialQueue:(dispatch_queue_t)queue;

#pragma mark - Removing
- (void)removeLastObject;
- (void)removeObjectAtIndex:(NSUInteger)index;

#pragma mark - Getting / Setting
- (void)addObject:(ObjectType)object;
- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;

#pragma mark Subscripting
- (void)setObject:(ObjectType)object atIndexedSubscript:(NSUInteger)idx;
- (ObjectType)objectAtIndexedSubscript:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
