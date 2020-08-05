//
//  SDLLockedMutableArray.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 8/4/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLockedMutableArray.h"

@interface SDLLockedMutableArray ()

@property (assign, nonatomic) dispatch_queue_t internalQueue;
@property (assign, nonatomic) const char *internalQueueID;

@property (strong, nonatomic) NSMutableArray *internalArray;

@end

@implementation SDLLockedMutableArray

#pragma mark - Initializers
- (instancetype)initWithSerialQueue:(dispatch_queue_t)queue {
    self = [super init];
    if (!self) { return nil; }

    _internalQueue = queue;
    _internalQueueID = [[NSUUID alloc] init].UUIDString.UTF8String;
    dispatch_queue_set_specific(_internalQueue, _internalQueueID, (void *)_internalQueueID, NULL);

    _internalArray = [[NSMutableArray alloc] init];

    return self;
}

#pragma mark - Removing
- (void)removeAllObjects {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalArray removeAllObjects];
    }];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf.internalArray removeObjectAtIndex:index];
    }];
}

#pragma mark - Getting / Setting

#pragma mark Retrieving information
- (NSUInteger)count {
    __block NSUInteger retVal = 0;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalArray.count;
    }];

    return retVal;
}

#pragma mark Adding Objects
- (void)addObject:(id)object {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf addObject:object];
    }];
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        [weakSelf insertObject:anObject atIndex:index];
    }];
}

#pragma mark Subscripting
- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    __block id retVal = nil;
    [self sdl_runSyncWithBlock:^{
        retVal = self.internalArray[idx];
    }];

    return retVal;
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)idx {
    __weak typeof(self) weakSelf = self;
    [self sdl_runAsyncWithBlock:^{
        weakSelf[idx] = object;
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
