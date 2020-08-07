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
@property (assign, nonatomic) const char *internalQueueID;

@property (strong, nonatomic) NSMutableDictionary *internalDict;

@end

@implementation SDLLockedMutableDictionary

- (instancetype)initWithQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) { return nil; }

    _internalQueue = queue;
    _internalQueueID = [[NSUUID alloc] init].UUIDString.UTF8String;
    dispatch_queue_set_specific(_internalQueue, _internalQueueID, (void *)_internalQueueID, NULL);

    _internalDict = [[NSMutableDictionary alloc] init];

    return self;
}

#pragma mark - Removing
- (void)removeAllObjects {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalDict removeAllObjects];
    }];
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        if ([weakSelf objectForKey:key] != nil) {
            [weakSelf.internalDict removeObjectForKey:key];
        }
    }];
}

#pragma mark - Getting / Setting
- (id)objectForKey:(id<NSCopying>)key {
    __block id retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = [self.internalDict objectForKey:key];
    }];

    return retVal;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalDict setObject:object forKey:key];
    }];
}

#pragma mark Retrieving Information

- (NSArray<id<NSCopying>> *)allKeys {
    __block NSArray<id<NSCopying>> *retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalDict.allKeys;
    }];

    return retVal;
}

- (NSArray<id> *)allValues {
    __block NSArray<id> *retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalDict.allValues;
    }];

    return retVal;
}

- (NSUInteger)count {
    __block NSUInteger retVal = 0;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalDict.count;
    }];

    return retVal;
}


#pragma mark Subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    __block id retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalDict[key];
    }];

    return retVal;
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        weakSelf.internalDict[key] = object;
    }];
}


# pragma mark - Utilities

- (void)sdl_runSyncWithBlock:(void (^)(void))block {
    if (dispatch_get_specific(_internalQueueID) != NULL) {
        block();
    } else {
        dispatch_sync(_internalQueue, block);
    }
}

- (void)sdl_runAsyncWithBlock:(void (^)(void))block {
    if (dispatch_get_specific(_internalQueueID) != NULL) {
        block();
    } else {
        dispatch_barrier_async(_internalQueue, block);
    }
}

@end
