//
//  SDLLockedMapTable.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/6/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMapTable.h"

@interface SDLLockedMapTable ()

@property (assign, nonatomic) dispatch_queue_t internalQueue;
@property (assign, nonatomic) const char *internalQueueID;

@property (strong, nonatomic) NSMapTable *internalMapTable;

@end

@implementation SDLLockedMapTable

#pragma mark - Initializers

- (instancetype)initWithKeyOptions:(NSPointerFunctionsOptions)keyOptions valueOptions:(NSPointerFunctionsOptions)valueOptions queue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) { return nil; }

    _internalQueue = queue;
    _internalQueueID = [[NSUUID alloc] init].UUIDString.UTF8String;
    dispatch_queue_set_specific(_internalQueue, _internalQueueID, (void *)_internalQueueID, NULL);

    _internalMapTable = [NSMapTable mapTableWithKeyOptions:keyOptions valueOptions:valueOptions];

    return self;
}

#pragma mark - Removing

- (void)removeAllObjects {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalMapTable removeAllObjects];
    }];
}

- (void)removeObjectForKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        if ([weakSelf objectForKey:key] != nil) {
            [weakSelf.internalMapTable removeObjectForKey:key];
        }
    }];
}

#pragma mark - Getting / Setting

- (id)objectForKey:(id<NSCopying>)key {
    __block id retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = [self.internalMapTable objectForKey:key];
    }];

    return retVal;
}

- (void)setObject:(id)object forKey:(id<NSCopying>)key {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalMapTable setObject:object forKey:key];
    }];
}

#pragma mark Subscripting

- (id)objectForKeyedSubscript:(id<NSCopying>)key {
    return [self objectForKey:key];
}

- (void)setObject:(id)object forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:object forKeyedSubscript:key];
}

#pragma mark Retrieving Information

- (NSUInteger)count {
    __block NSUInteger retVal = 0;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalMapTable.count;
    }];

    return retVal;
}

- (NSDictionary *)dictionaryRepresentation {
    __block NSDictionary *retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalMapTable.dictionaryRepresentation;
    }];

    return retVal;
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
