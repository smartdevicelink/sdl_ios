//
//  SDLLockedDictionary.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMutableDictionary.h"

@interface SDLLockedMutableDictionary ()

@property (assign, nonatomic) dispatch_queue_t internalQueue;
@property (strong, nonatomic) NSMutableDictionary *internalDict;

@end

@implementation SDLLockedMutableDictionary

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) { return nil; }

    _internalQueue = queue;
    _internalDict = [[NSMutableDictionary alloc] init];

    return self;
}

#pragma mark - Removing
- (void)removeAllObjects {
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_internalQueue, ^{
        [weakSelf.internalDict removeAllObjects];
    });
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_internalQueue, ^{
        [weakSelf.internalDict removeObjectForKey:key];
    });
}

#pragma mark - Getting / Setting
- (id)objectForKey:(id<NSCopying>)key {
    __block id retVal = nil;
    dispatch_sync(_internalQueue, ^{
        retVal = [_internalDict objectForKey:key];
    });

    return retVal;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_internalQueue, ^{
        [weakSelf.internalDict setObject:object forKey:key];
    });
}

#pragma mark Subscripting
- (id)objectAtIndexedSubscript:(id<NSCopying>)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)object atIndexedSubscript:(id<NSCopying>)key {
    [self setObject:object forKey:key];
}

@end
